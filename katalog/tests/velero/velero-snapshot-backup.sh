#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./../helper

@test "Deploy app" {
    info
    test() {
        apply katalog/tests/test-app-snapshot
        kubectl rollout status deployment/to-be-snapshotted --wait --timeout=5m
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Create file inside PV" {
    info
    test() {
        # No TTY needed in CI
        kubectl exec deployment/to-be-snapshotted -- touch /persistent-storage/HELLO_CI
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Trigger backup" {
    info
    test() {
        timeout 120 velero backup create backup-e2e-snapshot-full --from-schedule full -n kube-system --wait
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Verify that backup is completed" {
    info
    test() {
        velero -n kube-system backup get backup-e2e-snapshot-full | grep Completed
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}

@test "oops. Chaos...." {
    info
    test() {
        # No TTY needed in CI
        kubectl exec deployment/to-be-snapshotted -- rm /persistent-storage/HELLO_CI
        kubectl delete deployments -n default --all
        pv=$(kubectl get pvc to-be-snapshotted-pvc -o jsonpath='{.spec.volumeName}')
        kubectl delete pvc -n default --all
        kubectl delete pv "$pv"

        kubectl wait --for=delete deployment --all -n default --timeout=5m
        kubectl wait --for=delete pvc --all -n default --timeout=5m
        kubectl wait --for=delete pv "$pv" --timeout=5m
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Restore backup" {
    info
    test() {
        timeout 120 velero restore create --from-backup backup-e2e-snapshot-full -n kube-system --wait
        # Ensure restored deployment becomes ready before verification
        kubectl rollout status deployment/to-be-snapshotted --wait --timeout=5m
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Test Recovery that deleted files are present" {
    info
    test() {
        # No TTY needed in CI
        kubectl exec -n default deployment/to-be-snapshotted -- ls /persistent-storage/HELLO_CI
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}

@test "Delete backup" {
    info
    test(){
        velero backup delete backup-e2e-snapshot-full --confirm -n kube-system
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Delete app" {
    info
    test(){
        kustomize build katalog/tests/test-app-snapshot | kubectl delete -f -
    }
    run test
    [ "$status" -eq 0 ]
}
