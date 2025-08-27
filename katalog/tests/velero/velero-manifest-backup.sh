#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./../helper

@test "Trigger backup" {
    info
    test() {
        timeout 120 velero backup create backup-e2e --from-schedule manifests -n kube-system --wait
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Verify that backup is completed" {
    info
    test() {
        velero -n kube-system backup get backup-e2e | grep Completed
    }
    loop_it test 40 10
    [ "$status" -eq 0 ]
}

@test "oops. Chaos...." {
    info
    test() {
        kubectl delete service velero -n kube-system
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Restore backup" {
    info
    test() {
        timeout 120 velero restore create --from-backup backup-e2e -n kube-system --wait
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Test Recovery" {
    info
    test() {
        kubectl get service velero -n kube-system
    }
    loop_it test 30 15
    [ "$status" -eq 0 ]
}

@test "Delete backup" {
    info
    test(){
        velero backup delete backup-e2e --confirm -n kube-system
    }
    run test
    [ "$status" -eq 0 ]
}