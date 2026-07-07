# ETCD Backup S3

<!-- <SD-DOCS> -->

## Overview

ETCD Backup S3 runs a Kubernetes CronJob that snapshots the cluster's etcd database and uploads the snapshots to an S3-compatible storage target using `rclone`, cleaning up old backups based on a configurable retention policy. The job runs on a control plane node, uses the host network, and is fault-tolerant: it queries the cluster for a healthy etcd node and snapshots one of them.

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It applies to `OnPremises` (self-managed) clusters where you control etcd, and is selected automatically based on the `etcdBackup` configuration. See the [module documentation](../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)
