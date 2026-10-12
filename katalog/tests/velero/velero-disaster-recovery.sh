#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Disaster recovery across clusters: back up on cluster A, delete cluster A, restore on a new cluster B.
# Backups are stored on a MinIO container outside the clusters, on the kind docker network.
# Unlike the other suites, this one creates and deletes its own kind clusters.

# shellcheck disable=SC2154

load ./../helper

DR_PREFIX=${CLUSTER_NAME:-velero-dr}
DR_NODE_IMAGE=registry.sighup.io/fury/kindest/node:${CLUSTER_VERSION:-v1.36.4}
DR_MINIO=${DR_PREFIX}-minio
DR_MINIO_IMAGE=registry.sighup.io/fury/minio:RELEASE.2026-07-17T12-07-51Z-chainguard
DR_MC_IMAGE=registry.sighup.io/fury/minio/mc:RELEASE.2025-08-13T08-35-41Z

use_cluster(){
  export KUBECONFIG="${BATS_FILE_TMPDIR}/kubeconfig-$1"
}

create_cluster(){
  kind create cluster --name "${DR_PREFIX}-$1" --image "${DR_NODE_IMAGE}" --config katalog/tests/kind-config.yml --kubeconfig "${BATS_FILE_TMPDIR}/kubeconfig-$1"
}

# install_velero <access mode> installs Velero with the BackupStorageLocation pointing to the external MinIO.
install_velero(){
  set -e
  minio_ip=$(docker inspect -f '{{.NetworkSettings.Networks.kind.IPAddress}}' "${DR_MINIO}")
  kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v3.5.0/katalog/prometheus-operator/crds/0prometheusruleCustomResourceDefinition.yaml
  kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v3.5.0/katalog/prometheus-operator/crds/0servicemonitorCustomResourceDefinition.yaml
  # The first apply creates the CRDs but fails on the Velero CRs until the CRDs are established
  for _ in $(seq 1 30); do apply katalog/velero/velero-on-prem && break; sleep 10; done
  apply katalog/velero/velero-on-prem
  kubectl patch backupstoragelocation default -n kube-system --type merge \
    -p "{\"spec\":{\"accessMode\":\"$1\",\"config\":{\"s3Url\":\"http://${minio_ip}:9000\"}}}"
  apply katalog/velero/velero-node-agent
  kubectl wait --for=jsonpath='{.status.phase}'=Available backupstoragelocation/default -n kube-system --timeout=10m
  kubectl rollout status deployment/velero -n kube-system --timeout=10m
  kubectl rollout status daemonset/node-agent -n kube-system --timeout=10m
}

teardown_file(){
  kind delete cluster --name "${DR_PREFIX}-a" --kubeconfig "${BATS_FILE_TMPDIR}/kubeconfig-a" || true
  kind delete cluster --name "${DR_PREFIX}-b" --kubeconfig "${BATS_FILE_TMPDIR}/kubeconfig-b" || true
  docker rm -f "${DR_MINIO}" || true
}

@test "Create cluster A" {
    info
    run create_cluster a
    [ "$status" -eq 0 ]
}

@test "Start MinIO outside the clusters" {
    info
    run docker run -d --name "${DR_MINIO}" --network kind \
      -e MINIO_ROOT_USER=minio -e MINIO_ROOT_PASSWORD=minio123 \
      "${DR_MINIO_IMAGE}" server /data
    [ "$status" -eq 0 ]
}

@test "Create bucket on MinIO" {
    info
    test() {
        docker run --rm --network kind -e MC_HOST_dr="http://minio:minio123@${DR_MINIO}:9000" "${DR_MC_IMAGE}" mb -p dr/kube-system
    }
    loop_it test 30 2
    [ "$status" -eq 0 ]
}

@test "Install Velero on cluster A" {
    info
    use_cluster a
    run install_velero ReadWrite
    [ "$status" -eq 0 ]
}

@test "Deploy app on cluster A" {
    info
    use_cluster a
    test() {
        apply katalog/tests/test-app
        kubectl rollout status deployment/mysql --watch --timeout=10m
        write_test_data mysql /var/lib/mysql/HELLO_CI
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Backup on cluster A" {
    info
    use_cluster a
    test() {
        timeout 10m velero backup create backup-e2e-dr --include-namespaces default -n kube-system --wait
        kubectl wait --for=jsonpath='{.status.phase}'=Completed backup/backup-e2e-dr -n kube-system --timeout=10m
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Disaster: delete cluster A" {
    info
    run kind delete cluster --name "${DR_PREFIX}-a" --kubeconfig "${BATS_FILE_TMPDIR}/kubeconfig-a"
    [ "$status" -eq 0 ]
}

@test "Create cluster B" {
    info
    run create_cluster b
    [ "$status" -eq 0 ]
}

@test "Install Velero on cluster B with a read-only BackupStorageLocation" {
    info
    use_cluster b
    run install_velero ReadOnly
    [ "$status" -eq 0 ]
}

@test "Backup from cluster A is synced on cluster B" {
    info
    use_cluster b
    test() {
        kubectl get backup backup-e2e-dr -n kube-system -o jsonpath='{.status.phase}' | grep -qx Completed
    }
    loop_it test 30 10
    [ "$status" -eq 0 ]
}

@test "Restore on cluster B" {
    info
    use_cluster b
    test() {
        # Caveat, to restore a `local` pv, the pv must be manually created
        kubectl apply -n default -f katalog/tests/test-app/resources/sc.yaml
        kubectl apply -n default -f katalog/tests/test-app/resources/pv.yaml
        timeout 10m velero restore create restore-e2e-dr --from-backup backup-e2e-dr -n kube-system --wait
        kubectl rollout status deployment/mysql --watch --timeout=10m
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Verify that restore is completed on cluster B" {
    info
    use_cluster b
    run restore_completed restore-e2e-dr
    [ "$status" -eq 0 ]
}

@test "Data restored on cluster B has the same content as on cluster A" {
    info
    use_cluster b
    test() {
        verify_test_data mysql /var/lib/mysql/HELLO_CI
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}
