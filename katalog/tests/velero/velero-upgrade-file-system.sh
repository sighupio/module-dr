#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

load ./../helper

@test "Deploy app and create marker file" {
    info
    test() {
        apply katalog/tests/test-app
        kubectl rollout status deployment/mysql --watch --timeout=10m
        kubectl exec deployment/mysql -- touch /var/lib/mysql/HELLO_CI
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Create backup from manifests schedule" {
    info
    test() {
        timeout 10m velero backup create backup-e2e-app-upgrade --from-schedule manifests -n kube-system --wait
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Verify backup completed" {
    info
    run kubectl wait --for=jsonpath='{.status.phase}'=Completed backup/backup-e2e-app-upgrade -n kube-system --timeout=10m
    [ "$status" -eq 0 ]
}

@test "Upgrade to current module" {
    info
    test() {
        kubectl delete job -n kube-system minio-setup
        apply katalog/velero/snapshot-controller
        apply katalog/velero/velero-on-prem
        apply katalog/velero/velero-node-agent
        apply katalog/velero/velero-schedules

        kubectl wait --for=jsonpath='{.status.phase}'=Available backupstoragelocation/default -n kube-system --timeout=10m
        kubectl rollout status deployment/velero -n kube-system --timeout=10m
        kubectl rollout status daemonset/node-agent -n kube-system --timeout=10m
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Induce failure by deleting app and PV" {
    info
    test() {
        kubectl exec deployment/mysql -- rm /var/lib/mysql/HELLO_CI || true
        kubectl delete deployments -n default --all
        kubectl delete pvc -n default --all
        kubectl delete pv mysql-pv || true
        kubectl wait --for=delete deployment --all -n default --timeout=10m
        kubectl wait --for=delete pvc --all -n default --timeout=10m
        kubectl wait --for=delete pv mysql-pv --timeout=10m || true
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Restore backup after upgrade" {
    info
    test() {
        # restore requires static PV for this app
        kubectl apply -n default -f katalog/tests/test-app/resources/pv.yaml
        timeout 10m velero restore create --from-backup backup-e2e-app-upgrade -n kube-system --wait
        kubectl rollout status deployment/mysql --watch --timeout=10m
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Verify restored marker file exists" {
    info
    test() {
        kubectl exec -n default deployment/mysql -- ls /var/lib/mysql/HELLO_CI
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}

@test "Cleanup backup and app" {
    info
    test(){
        velero backup delete backup-e2e-app-upgrade --confirm -n kube-system || true
        kustomize build katalog/tests/test-app | kubectl delete -f - || true
    }
    run test
    [ "$status" -eq 0 ]
}

