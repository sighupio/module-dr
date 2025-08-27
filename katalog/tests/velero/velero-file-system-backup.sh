#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./../helper

@test "Deploy app" {
    info
    test() {
        apply katalog/tests/test-app
        sleep 10
        kubectl exec -it deployment/mysql -- touch /var/lib/mysql/HELLO_CI

    }
    run test
    [ "$status" -eq 0 ]
}

@test "Trigger backup" {
    info
    test() {
        timeout 120 velero backup create backup-e2e-app --from-schedule manifests -n kube-system --wait
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Verify that backup is completed" {
    info
    test() {
        velero -n kube-system backup get backup-e2e-app | grep Completed
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}

@test "oops. Chaos...." {
    info
    test() {
        kubectl exec -it deployment/mysql -- rm /var/lib/mysql/HELLO_CI
        kubectl delete deployments -n default --all
        kubectl delete pvc -n default --all
        kubectl delete pv mysql-pv
        sleep 15
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Restore backup" {
    info
    test() {
        # Caveat, to restore a `local` pv, the pv must be manually created, restic expects dynamic pv creation
        kubectl apply -n default -f katalog/tests/test-app/resources/pv.yaml
        timeout 120 velero restore create --from-backup backup-e2e-app -n kube-system --wait
    }
    run test
    [ "$status" -eq 0 ]
}


@test "Test Recovery that deleted files are present" {
    info
    test() {
        kubectl exec -it -n default deployment/mysql -- ls /var/lib/mysql/HELLO_CI
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}

@test "Delete backup" {
    info
    test(){
        velero backup delete backup-e2e-app --confirm -n kube-system
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Delete app" {
    info
    test(){
        kustomize build katalog/tests/test-app | kubectl delete -f -
    }
    run test
    [ "$status" -eq 0 ]
}