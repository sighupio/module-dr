# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#!/usr/bin/env bats

# shellcheck disable=SC2086,SC2154,SC2034

apply (){
  kustomize build $1 >&2
  kustomize build $1 | kubectl apply -f - 2>&3
}

delete (){
  kustomize build $1 >&2
  kustomize build $1 | kubectl delete -f - 2>&3
}

info(){
  echo -e "${BATS_TEST_NUMBER}: ${BATS_TEST_DESCRIPTION}" >&3
}

loop_it(){
  retry_counter=0
  max_retry=${2:-100}
  wait_time=${3:-2}
  run ${1}
  ko=${status}
  loop_it_result=${ko}
  while [[ ko -ne 0 ]]
  do
    if [ $retry_counter -ge $max_retry ]; then echo "Timeout waiting a condition"; return 1; fi
    sleep ${wait_time} && echo "# waiting..." $retry_counter >&3
    run ${1}
    ko=${status}
    loop_it_result=${ko}
    retry_counter=$((retry_counter + 1))
  done
  return 0
}

# restore_completed <name> succeeds only if the Restore reached the Completed phase.
# `velero restore create --wait` exits 0 also on PartiallyFailed/Failed, so this must be checked explicitly.
restore_completed(){
  phase=$(kubectl get restore "$1" -n kube-system -o jsonpath='{.status.phase}')
  if [ "${phase}" != "Completed" ]; then
    echo "# Restore $1 phase: ${phase}" >&3
    velero restore describe "$1" -n kube-system --details >&3
    return 1
  fi
}

# write_test_data <deployment> <file> writes 10 MiB of random data into <file> inside the deployment pod
# and stores its sha256 checksum in the bats file tmpdir, to be checked later with verify_test_data.
write_test_data(){
  kubectl exec -n default deployment/$1 -- sh -c "head -c 10485760 /dev/urandom > $2"
  kubectl exec -n default deployment/$1 -- sha256sum $2 | cut -d' ' -f1 > "${BATS_FILE_TMPDIR}/$1.sha256"
  [ -s "${BATS_FILE_TMPDIR}/$1.sha256" ]
}

# verify_test_data <deployment> <file> succeeds only if <file> has the checksum stored by write_test_data.
verify_test_data(){
  expected=$(cat "${BATS_FILE_TMPDIR}/$1.sha256")
  actual=$(kubectl exec -n default deployment/$1 -- sha256sum $2 | cut -d' ' -f1)
  [ -n "${expected}" ] && [ "${actual}" = "${expected}" ]
}
