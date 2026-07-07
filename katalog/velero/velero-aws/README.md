# Velero AWS

<!-- <SD-DOCS> -->

## Overview

Velero AWS deploys Velero together with the AWS plugin so that backups are stored in an S3 bucket and volume snapshots use AWS EBS. It builds on top of `velero-base` and expects the `cloud-credentials` secret and a `default` BackupStorageLocation to be available.

## Upstream project

This package is based on the upstream [Velero plugin for AWS][plugin].

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It is an internal building block selected automatically when the chosen provider uses an AWS S3 backend. See the [module documentation](../../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- Links -->

[plugin]: https://github.com/vmware-tanzu/velero-plugin-for-aws

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)
