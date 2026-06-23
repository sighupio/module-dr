<!-- markdownlint-disable MD033 -->
<h1 align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/black-logo.png">
  <img alt="Shows a black logo in light color mode and a white one in dark color mode." src="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
</picture><br/>
  Disaster Recovery Module
</h1>
<!-- markdownlint-enable MD033 -->

![Release](https://img.shields.io/badge/Latest%20Release-v3.4.0-blue)
![License](https://img.shields.io/github/license/sighupio/module-dr?label=License)
[![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)](https://kubernetes.slack.com/archives/C0154HYTAQH)

<!-- <SD-DOCS> -->

**Disaster Recovery Module** implements backups and disaster recovery for [SIGHUP Distribution (SD)][kfd-repo].

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

**Disaster Recovery Module** is based on [Velero][velero-page] (with [Velero Node Agent][velero-node-agent-page] for volume backups) and on etcd backups.

Velero allows you to back up and restore your cluster resources and persistent volumes, migrate resources between clusters, and replicate your production environment to development and testing environments. When the [`snapshot-controller`](katalog/velero/snapshot-controller) is enabled, [CSI Snapshot Data Movement][csi-data-movement] provides consistent backups of volume data to a backup storage location.

The etcd backup packages snapshot the cluster's etcd database to an S3 bucket or to a PersistentVolumeClaim, on self-managed clusters where you control etcd.

The module also includes Velero plugins to integrate natively with different cloud providers and use their object storage as the backup backend.

## Packages

Disaster Recovery Module provides the following packages:

| Package                                    | Version     | Description                                                                                                     |
| ------------------------------------------ | ----------- | --------------------------------------------------------------------------------------------------------------- |
| [velero](katalog/velero)                   | `v1.18.1`   | Backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes. |
| [etcd-backup-s3](katalog/etcd-backup-s3)   | `homegrown` | Backup etcd on a remote S3 bucket.                                                                              |
| [etcd-backup-pvc](katalog/etcd-backup-pvc) | `homegrown` | Backup etcd on a PersistentVolumeClaim.                                                                         |

The velero package contains the following additional components:

| Component                                                   | Description                                                            |
| ----------------------------------------------------------- | ---------------------------------------------------------------------- |
| [velero-base](katalog/velero/velero-base)                   | Common Velero components shared by all backends.                       |
| [velero-node-agent](katalog/velero/velero-node-agent)       | Incremental backup and restore of Kubernetes volumes.                  |
| [velero-schedules](katalog/velero/velero-schedules)         | Common schedules for backup.                                           |
| [snapshot-controller](katalog/velero/snapshot-controller)   | Enables CSI Snapshot Data Movement support.                            |
| [velero-aws](katalog/velero/velero-aws)                     | Plugin to support running Velero on AWS.                               |
| [velero-gcp](katalog/velero/velero-gcp)                     | Plugin to support running Velero on GCP.                               |
| [velero-azure](katalog/velero/velero-azure)                 | Plugin to support running Velero on Azure.                             |
| [velero-on-prem](katalog/velero/velero-on-prem)             | In-cluster MinIO object storage backend for on-premises clusters.      |

The following Terraform modules provision the cloud infrastructure used to persist the backups natively in cloud providers' object storage:

| Terraform Module                     | Description                                                     |
| ------------------------------------ | --------------------------------------------------------------- |
| [aws-velero](modules/aws-velero)     | Creates AWS resources and Kubernetes CRDs to persist backups.   |
| [azure-velero](modules/azure-velero) | Creates Azure resources and Kubernetes CRDs to persist backups. |
| [gcp-velero](modules/gcp-velero)     | Creates GCP resources and Kubernetes CRDs to persist backups.   |

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.33.x`           | :white_check_mark: | No known issues |
| `1.34.x`           | :white_check_mark: | No known issues |
| `1.35.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

**Disaster Recovery Module** is part of SIGHUP Distribution (SD) and is deployed automatically by [`furyctl`][furyctl-repo] when you create or update a cluster. You don't need to download, vendor or install its packages manually.

### Configuration

You configure the module under `spec.distribution.modules.dr` in your `furyctl.yaml`. The `type` field selects whether disaster recovery is enabled: `none` to disable it, or the value matching your cluster kind — `eks` on `EKSCluster`, `on-premises` on `KFDDistribution` and `OnPremises`. The `velero.backend` field selects the storage backend for the backups (`minio`, `externalEndpoint` or `gcs`). The other fields are optional and fall back to sensible defaults.

```yaml
apiVersion: kfd.sighup.io/v1alpha2
kind: KFDDistribution
spec:
  distribution:
    modules:
      dr:
        type: on-premises
        velero:
          backend: minio
```

See the configuration reference for your cluster kind for the full list of available options: [EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd] or [OnPremises][schema-reference-onprem].

To install SD from scratch, follow the [Getting started][getting-started] guide.

<!-- Links -->

[velero-page]: https://velero.io
[velero-node-agent-page]: https://velero.io/docs/v1.18/file-system-backup/
[csi-data-movement]: https://velero.io/docs/main/csi-snapshot-data-movement/
[kfd-repo]: https://github.com/sighupio/distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kfd-docs]: https://docs.sighup.io/docs/distribution/
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesdr
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesdr
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesdr
[getting-started]: https://docs.sighup.io/docs/getting-started/
[compatibility-matrix]: https://github.com/sighupio/module-dr/blob/main/docs/COMPATIBILITY_MATRIX.md

<!-- </SD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](https://github.com/sighupio/distribution/blob/main/docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/module-dr/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE).

<!-- </FOOTER> -->
