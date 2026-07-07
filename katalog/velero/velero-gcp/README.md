# Velero GCP

<!-- <SD-DOCS> -->

## Overview

Velero GCP deploys Velero together with the GCP plugin so that backups are stored in a GCS bucket and volume snapshots use GCP persistent disks. It builds on top of `velero-base` and expects the `cloud-credentials` secret and a `default` BackupStorageLocation to be available.

## Upstream project

This package is based on the upstream [Velero plugin for GCP][plugin].

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It is an internal building block selected automatically when the chosen backend is `gcs`. See the [module documentation](../../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- Links -->

[plugin]: https://github.com/vmware-tanzu/velero-plugin-for-gcp

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)
