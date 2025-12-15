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

![Release](https://img.shields.io/badge/Latest%20Release-v3.3.0-blue)
![License](https://img.shields.io/github/license/sighupio/module-dr?label=License)
[![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)](https://kubernetes.slack.com/archives/C0154HYTAQH)

<!-- <SD-DOCS> -->

**Disaster Recovery Module** implements backups and disaster recovery for the [SIGHUP Distribution (SD)][skd-repo] using [Velero][velero-page].

If you are new to SD please refer to the [official documentation][skd-docs] on how to get started with SD.

## Overview

**Disaster Recovery Module** module is based on [Velero][velero-page], [Velero Node Agent][velero-node-agent-page] and etcd backup ([S3][etcd-backup-s3-link]/[PVC][etcd-backup-pvc-link]).

Velero allows you to:

- backup your cluster
- restore your cluster in case of problems
- migrate cluster resources to other clusters
- replicate your production environment to development and testing environment.

ETCD backup allows you to:

- snapshot your ETCD cluster on an S3 bucket
- snapshot your ETCD cluster on an already provisioned PVC

Together with Velero, Velero Node Agent allows you to:

- backup Kubernetes volumes
- restore Kubernetes volumes

And by using the [`snapshot-controller`](../../katalog/velero/snapshot-controller/README.md), the support for [CSI Snapshot Data Movement](https://velero.io/docs/main/csi-snapshot-data-movement/) can be enabled, which allows you to:

- backup the volume data to a pre-defined backup storage
- have **consistent** backups of your data

The module contains also velero plugins to natively integrate with Velero with different cloud providers and use cloud provider's volumes as the storage backend.

## Packages

Disaster Recovery Module provides the following packages:

| Package                                    | Version     | Description                                                                                                     |
| ------------------------------------------ | ----------- | --------------------------------------------------------------------------------------------------------------- |
| [velero](katalog/velero)                   | `v1.16.2`    | Backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes. |
| [etcd-backup-s3](katalog/etcd-backup-s3)   | `homegrown` | Backup ETCD on a remote S3 bucket.                                                                              |
| [etcd-backup-pvc](katalog/etcd-backup-pvc) | `homegrown` | Backup ETCD on a PersistentVolumeClaim.                                                                         |

The velero package contains the following additional components:

| Component                                           | Description                                           |
| --------------------------------------------------- | ----------------------------------------------------- |
| [velero-node-agent](katalog/velero/velero-node-agent)       | Incremental backup and restore of Kubernetes volumes. |
| [velero-schedules](katalog/velero/velero-schedules) | Common schedules for backup                           |

### Integration with cloud providers

Use the following Velero Plugins to integrate Velero with cloud providers:

| Plugin                                      | Description                                |
| ------------------------------------------- | ------------------------------------------ |
| [velero-aws](katalog/velero/velero-aws)     | Plugins to support running Velero on AWS   |
| [velero-gcp](katalog/velero/velero-gcp)     | Plugins to support running Velero on GCP   |
| [velero-azure](katalog/velero/velero-azure) | Plugins to support running Velero on Azure |

Deploy the necessary infrastructure to persist the backups natively in cloud providers volumes, using the following terraform modules:

| Terraform Module                     | Description                                                     |
| ------------------------------------ | --------------------------------------------------------------- |
| [aws-velero](modules/aws-velero)     | Creates AWS resources and Kubernetes CRDs to persist backups.   |
| [azure-velero](modules/azure-velero) | Creates Azure resources and Kubernetes CRDs to persist backups. |
| [gcp-velero](modules/gcp-velero)     | Creates GCP resources and Kubernetes CRDs to persist backups.   |

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.29.x`           | :white_check_mark: | No known issues |
| `1.30.x`           | :white_check_mark: | No known issues |
| `1.31.x`           | :white_check_mark: | No known issues |
| `1.32.x`           | :white_check_mark: | No known issues |
| `1.33.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

**Disaster Recovery Module**'s Velero deployment depends on the environment.

| Environment                               | Storage Backend      | Velero Plugin                                   | Terraform Module                     |
| ----------------------------------------- | -------------------- | ----------------------------------------------- | ------------------------------------ |
| [Velero on AWS](#velero-on-aws)           | S3 Bucket            | [velero-aws](katalog/velero/velero-aws)         | [aws-velero](modules/aws-velero)     |
| [Velero on GCP](#velero-on-gcp)           | GCS                  | [velero-gcp](katalog/velero/velero-gcp)         | [gcp-velero](modules/gcp-velero)     |
| [Velero on Azure](#velero-on-azure)       | AZ Storage Container | [velero-azure](katalog/velero/velero-azure)     | [azure-velero](modules/azure-velero) |
| [Velero on-premises](#velero-on-premises) | MinIo                | [velero-on-prem](katalog/velero/velero-on-prem) | `/`                                  |

**Disaster Recovery Module**'s etcd-backup deployment depends on the final location of the backups.
| Package                                   | Storage Location        |
| ----------------------------------------- | ----------------------- |
| [etcd-backup-s3](#etcd-backup-s3)         | S3 Bucket               |
| [etcd-backup-pvc](#etcd-backup-pvc)       | PersistentVolumeClaim   |


### Prerequisites

| Tool                        | Version    | Description                                                                                                                                                    |
| --------------------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.25.0` | The recommended tool to download and manage SD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.3`  | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |
| [terraform][terraform-page] | `>=1.3`    | Additional infrastructure is deployed using `terraform`.                                                                                                       |

### Velero on AWS

Velero on AWS is based on the [AWS Velero Plugin][velero-aws-plugin-repo].

It requires the secret `cloud-credentials` in the `kube-system` namespace containing a service account with appropriate credentials.
As an alternative, the module supports [authentication via IAM Roles][aws-docs-iam-roles].

To deploy Velero on AWS:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: dr/velero/velero-base
    version: "v3.3.0"
  - name: dr/velero/velero-aws
    version: "v3.3.0"
  - name: dr/velero/velero-node-agent
    version: "v3.3.0"
  - name: dr/velero/velero-schedules
    version: "v3.3.0"

modules:
  - name: dr/aws-velero
    version: "v3.3.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl legacy vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Deploy the necessary infrastructure via terraform using the `aws-velero` terraform module:

```hcl
module "velero" {
  source             = "path/to/vendor/modules/aws-velero"
  backup_bucket_name = "my-cluster-velero"
  project            = "sighup-staging"
}
```

> More information on modules inputs can be found in the [aws-velero](modules/aws-velero) module documentation
>
> [Here][skd-velero-aws-example] you can find an example designed to create all necessary cloud resources for Velero on AWS.

5. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-aws
  - ./vendor/katalog/dr/velero/velero-node-agent
  - ./vendor/katalog/dr/velero/velero-schedules
```

6. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### Velero on GCP

Velero on GCP is based on the [Velero GCP Plugin][velero-gcp-plugin-repo].

It requires the secret `cloud-credentials` in the `kube-system` namespace containing a service account with appropriate credentials.
As an alternative, the module supports workload identity.

> Check the required Velero GCP plugin permissions [here][velero-gcp-plugin-repo-permissions]

To deploy Velero on GCP:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: dr/velero/velero-base
    version: "v3.3.0"
  - name: dr/velero/velero-gcp
    version: "v3.3.0"
  - name: dr/velero/velero-node-agent
    version: "v3.3.0"
  - name: dr/velero/velero-schedules
    version: "v3.3.0"

modules:
  - name: dr/gcp-velero
    version: "v3.3.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl legacy vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Deploy the necessary infrastructure via terraform using the `gcp-velero` terraform module:

```hcl
module "velero" {
  source             = "path/to/vendor/modules/gcp-velero"
  backup_bucket_name = "my-cluster-velero"
  project            = "sighup-staging"
}
```

> More information on modules inputs can be found in the [gcp-velero](modules/gcp-velero) module documentation
>
> [Here][skd-velero-gcp-example] you can find an example designed to create all necessary cloud resources for Velero on GCP.

5. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-gcp
  - ./vendor/katalog/dr/velero/velero-node-agent
  - ./vendor/katalog/dr/velero/velero-schedules
```

6. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### Velero on Azure

Velero on Azure is based on the [Azure Velero Plugin][velero-azure-plugin-repo].

Requires the `cloud-credentials` `secret` config in the `kube-system` namespace.

To deploy Velero on Azure:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: dr/velero/velero-base
    version: "v3.3.0"
  - name: dr/velero/velero-azure
    version: "v3.3.0"
  - name: dr/velero/velero-node-agent
    version: "v3.3.0"
  - name: dr/velero/velero-schedules
    version: "v3.3.0"

modules:
  - name: dr/azure-velero
    version: "v3.3.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl legacy vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Deploy the necessary infrastructure via terraform using the `azure-velero` terraform module:

```hcl
module "velero" {
  source             = "path/to/vendor/modules/azure-velero"
  backup_bucket_name = "my-cluster-velero"
  project            = "sighup-staging"
}
```

> More information on modules inputs can be found in the [azure-velero](modules/azure-velero) module documentation
>
> [Here][skd-velero-azure-example] you can find an example designed to create all necessary cloud resources for Velero on Azure.

5. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-azure
  - ./vendor/katalog/dr/velero/velero-node-agent
  - ./vendor/katalog/dr/velero/velero-schedules
```

6. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### Velero on-premises

[velero-on-prem][skd-velero-on-prem] deploys a [MinIO][minio-page] in-cluster instance as an object storage backend for Velero.

Please note that the MinIO server is running in the same cluster that is being backed up.

To deploy `velero on-prem`:

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: dr/velero/velero-base
    version: "v3.3.0"
  - name: dr/velero/velero-on-prem
    version: "v3.3.0"
  - name: dr/velero/velero-node-agent
    version: "v3.3.0"
  - name: dr/velero/velero-schedules
    version: "v3.3.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl legacy vendor -H` to download the packages

3. Inspect the downloaded packages under `./vendor/katalog/velero`.

4. Define a `kustomization.yaml` that includes the downloaded resources.

```yaml
resources:
  - ./vendor/katalog/dr/velero/velero-on-prem
  - ./vendor/katalog/dr/velero/velero-node-agent
  - ./vendor/katalog/dr/velero/velero-schedules
```

5. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

### ETCD Backup S3
[etcd-backup-s3][etcd-backup-s3-link] deploys a *CronJob* that continuously backups the etcd cluster and saves the snapshots in a S3 bucket.
In order to deploy `etcd-backup-s3`, please refer to the [package's README.md][etcd-backup-s3-link].

### ETCD Backup PVC
[etcd-backup-pvc][etcd-backup-pvc-link] deploys a *CronJob* that continuously backups the etcd cluster and saves the snapshots in a PersistentVolumeClaim.
In order to deploy `etcd-backup-pvc`, please refer to the [package's README.md][etcd-backup-pvc-link].

<!-- Links -->

[sighup-page]: https://sighup.io
[velero-page]: https://velero.io
[velero-node-agent-page]: https://velero.io/docs/v1.16/file-system-backup/
[minio-page]: https://min.io/
[terraform-page]: https://www.terraform.io/
[skd-repo]: https://github.com/sighupio/distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kustomize-repo]: https://github.com/kubernetes-sigs/kustomize
[velero-gcp-plugin-repo]: https://github.com/vmware-tanzu/velero-plugin-for-gcp
[velero-aws-plugin-repo]: https://github.com/vmware-tanzu/velero-plugin-for-aws
[velero-azure-plugin-repo]: https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure
[velero-gcp-plugin-repo-permissions]: https://github.com/vmware-tanzu/velero-plugin-for-gcp#set-permissions-for-velero
[skd-velero-gcp-example]: https://github.com/sighupio/module-dr/tree/main/examples/gcp-examples/main.tf
[skd-velero-aws-example]: https://github.com/sighupio/module-dr/tree/main/examples/aws-examples/main.tf
[skd-velero-azure-example]: https://github.com/sighupio/module-dr/tree/main/examples/azure-examples/main.tf
[skd-velero-on-prem]: https://github.com/sighupio/module-dr/tree/main/katalog/velero/velero-on-prem
[aws-docs-iam-roles]: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
[skd-docs]: https://docs.sighup.io/
[compatibility-matrix]: https://github.com/sighupio/module-dr/blob/master/docs/COMPATIBILITY_MATRIX.md
[etcd-backup-s3-link]: https://github.com/sighupio/module-dr/blob/master/katalog/etcd-backup-s3/README.md
[etcd-backup-pvc-link]: https://github.com/sighupio/module-dr/blob/master/katalog/etcd-backup-pvc/README.md
<!-- </SD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/module-dr/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
