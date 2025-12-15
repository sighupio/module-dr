#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2154

load ./../helper

@test "Applying Monitoring" {
    info
    kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v3.5.0/katalog/prometheus-operator/crds/0prometheusruleCustomResourceDefinition.yaml
    kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v3.5.0/katalog/prometheus-operator/crds/0servicemonitorCustomResourceDefinition.yaml
}

@test "Deploy previous version of the Snapshot Controller" {
    info
    test() {
        apply https://github.com/sighupio/module-dr.git/katalog/velero/snapshot-controller?ref=v3.2.0
    }
    loop_it test 30 10
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Deploy csi-driver-host-path" {
    info
    test() {
        # Use a unique temp dir to avoid /tmp collisions under parallel runs
        tmpdir=$(mktemp -d -t csi-driver-XXXXXX)
        git clone --depth 1 --branch v1.17.0 https://github.com/kubernetes-csi/csi-driver-host-path "$tmpdir"
        "$tmpdir"/deploy/kubernetes-1.30/deploy.sh

        # Install VolumeSnapshotClass and StorageClass.
        kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/refs/tags/v1.17.0/examples/csi-storageclass.yaml
        kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/refs/tags/v1.17.0/examples/csi-volumesnapshotclass.yaml
        rm -rf "$tmpdir"
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Deploy Velero on Prem" {
    info
    test() {
        apply https://github.com/sighupio/module-dr.git//katalog/velero/velero-on-prem?ref=v3.1.0
    }
    loop_it test 30 10
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Check BackupStorageLocation" {
    info
    # Wait for BSL to become Available instead of polling
    run kubectl wait \
        --for=jsonpath='{.status.phase}'=Available \
        backupstoragelocation/default \
        -n kube-system \
        --timeout=10m
    [ "$status" -eq 0 ]
}

@test "Velero is Running" {
    info
    # Wait for the Deployment rollout to complete
    run kubectl rollout status \
        deployment/velero \
        -n kube-system \
        --timeout=10m
    [ "$status" -eq 0 ]
}

@test "Deploy Velero Node Agent" {
    info
    test() {
        apply https://github.com/sighupio/module-dr.git/katalog/velero/velero-node-agent?ref=v3.2.0
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Velero Node Agent is Running" {
    info
    # Wait for the DaemonSet rollout to complete (all pods ready)
    run kubectl rollout status \
        daemonset/node-agent \
        -n kube-system \
        --timeout=10m
    [ "$status" -eq 0 ]
}

@test "Deploy Velero Schedules" {
    info
    test() {
        apply https://github.com/sighupio/module-dr.git//katalog/velero/velero-schedules?ref=v3.2.0
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Check minio setup Job" {
  info
  # Wait for minio-setup Job to complete
  run kubectl wait --for=condition=complete job/minio-setup -n kube-system --timeout=10m
  [ "$status" -eq 0 ]
}
