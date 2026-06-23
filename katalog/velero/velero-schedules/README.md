# Velero Schedules

<!-- <SD-DOCS> -->

## Overview

Velero Schedules provides a set of ready-to-use Velero `Schedule` resources to perform automatic backups: a full backup (cluster manifests and persistent volumes) and a manifests-only backup. The full schedule requires a `default` VolumeSnapshotLocation and the manifests schedule requires a `default` BackupStorageLocation, both of which are provisioned by the module for the chosen backend.

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It is an internal building block selected automatically based on the configured schedules. See the [module documentation](../../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)
