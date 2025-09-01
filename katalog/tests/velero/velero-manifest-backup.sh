#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./../helper

@test "Trigger backup" {
    info
    test() {
        # Give backup more time under load
        timeout 10m velero backup create backup-e2e --from-schedule manifests -n kube-system --wait
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Verify that backup is completed" {
    info
    # Wait for Velero Backup phase to be Completed
    run kubectl wait --for=jsonpath='{.status.phase}'=Completed backup/backup-e2e -n kube-system --timeout=10m
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
        # Give restore more time under load
        timeout 10m velero restore create --from-backup backup-e2e -n kube-system --wait
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
