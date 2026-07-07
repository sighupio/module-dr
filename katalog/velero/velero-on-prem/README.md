# Velero on Premises

<!-- <SD-DOCS> -->

## Overview

Velero on Premises deploys Velero with an in-cluster [MinIO][minio-page] instance as the S3-compatible object storage backend, using the AWS-compatible Velero plugin. It is intended for clusters that don't have access to a cloud provider's object storage. Note that the MinIO server runs in the same cluster that is being backed up.

## Upstream project

This package is based on the upstream [MinIO][minio-page] object storage server.

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It is an internal building block selected automatically when the chosen backend is `minio`. See the [module documentation](../../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- Links -->

[minio-page]: https://min.io/

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)
