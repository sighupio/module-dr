# Velero

![Velero Logo](../../docs/assets/velero.png)

- [Velero](#velero)
  - [Requirements](#requirements)
  - [Server deployment](#server-deployment)
    - [Velero on-premises](#velero-on-premises)
    - [Velero on AWS](#velero-on-aws)
    - [Velero on GCP](#velero-on-gcp)
    - [Velero on Azure](#velero-on-azure)
    - [Velero Node Agent](#velero-node-agent)
    - [Velero schedule](#velero-schedule)

<!-- <SD-DOCS> -->

Velero *(formerly Heptio Ark)* gives you tool to back up and restore your Kubernetes cluster resources and persistent
volumes. You can run Velero with a cloud provider or on-premises. Velero lets you:

- Take backups of your cluster and restore in case of loss.
- Migrate cluster resources to other clusters.
- Replicate your production cluster to development and testing clusters.

Velero consists of:

- A server that runs on your cluster
- A command-line client that runs locally

## Requirements

Velero requires to have already deployed the [prometheus-operator](https://github.com/coreos/prometheus-operator) CRDs
as this feature deploys [a `ServiceMonitor` definition](velero-base/serviceMonitor.yaml). It can be deployed using the
[skd-monitoring](https://github.com/sighupio/module-monitoring) SD core module.

## Server deployment

Every velero deployment, does not matter if on-premises or in any of the supported cloud, can configure
[schedules](#velero-schedule) to back up all cluster manifests and/or cluster persistence volumes.

### Velero on-premises

The [velero-on-prem](./velero-on-prem/) feature deploys a [MinIO](https://min.io/) instance in the same cluster as
object storage backend that Velero can use to store backup data.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - vendor/katalog/dr/velero/velero-base
  - vendor/katalog/dr/velero/velero-on-prem
```

### Velero on AWS

The [AWS deployment alternative](./velero-aws) requires to have created `cloud-credentials` secret in the
`kube-system` namespace.
You can find a [terraform module](../../modules/aws-velero) designed to create all necessary cloud resources
to make velero works in AWS.

You can find and example terraform project using the [aws-velero](../../modules/aws-velero) terraform module
[here](../../examples/aws-examples/main.tf)

```bash
$ cd examples/aws-example
$ terraform init
# omitted output
$ terraform apply --var="my_cluster_name=kubernetes-cluster-and-velero"
# omitted output
$ terraform output -raw cloud_credentials > /tmp/cloud_credentials.config
$ terraform output -raw volume_snapshot_location > /tmp/volume_snapshot_location.yaml
$ terraform output -raw backup_storage_location > /tmp/backup_storage_location.yaml
$ kubectl apply -f /tmp/cloud_credentials.config -n kube-system
# omitted output
$ kubectl apply -f /tmp/volume_snapshot_location.yaml -n kube-system
# omitted output
$ kubectl apply -f /tmp/backup_storage_location.yaml -n kube-system
# omitted output
```

Then, you will be able to deploy the velero AWS deployment.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - vendor/katalog/dr/velero/velero-base
  - vendor/katalog/dr/velero/velero-aws
```

More information about the [AWS Velero Plugin](https://github.com/vmware-tanzu/velero-plugin-for-aws)

### Velero on GCP

The [GCP deployment alternative](./velero-gcp) requires to have created `cloud-credentials` secret in the
`kube-system` namespace.
You can find a [terraform module](../../modules/gcp-velero) designed to create all necessary cloud resources
to make velero works in GCP.

Then, you will be able to deploy the velero GCP deployment.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - vendor/katalog/dr/velero/velero-base
  - vendor/katalog/dr/velero/velero-gcp
```

More information about the [GCP Velero Plugin](https://github.com/vmware-tanzu/velero-plugin-for-gcp)

### Velero on Azure

The [Azure deployment alternative](./velero-azure) requires to have created `cloud-credentials` secret in the
`kube-system` namespace.
You can find a [terraform module](../../modules/azure-velero) designed to create all necessary cloud resources
to make velero works in Azure.

Then, you will be able to deploy the velero Azure deployment.

*Example `kustomization.yaml` file*

```yaml
namespace: kube-system

bases:
  - vendor/katalog/dr/velero/velero-base
  - vendor/katalog/dr/velero/velero-azure
```

More information about the [Azure Velero Plugin](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure)

### Velero Node Agent

> [!IMPORTANT]  
> Velero Restic has been renamed to Velero Node Agent in v2.2.0

Velero has support for backing up and restoring Kubernetes volumes using free open-source backup tools like restic and kopia.

[velero-node-agent](./velero-node-agent) requires to have a velero deployment running in the cluster before deploy it.
Velero Node Agent is not tied to be deployed on prem or on cloud. So feel free to deploy it with your prefered velero
deployment.

```yaml
namespace: kube-system

bases:
  - vendor/katalog/dr/velero/velero-base
  - vendor/katalog/dr/velero/velero-aws
  - vendor/katalog/dr/velero/velero-node-agent
```

More information about [Velero Node Agent integration](https://velero.io/docs/v1.18/file-system-backup/)

### Velero schedule

This module contains a couple of useful [velero schedules](velero-schedules) to perform automatic backups of cluster manifests and/or
persistence volumes.

Feel free to deploy these schedules if fits in your business:

```yaml
namespace: kube-system

bases:
  - vendor/katalog/dr/velero/velero-base
  - vendor/katalog/dr/velero/velero-aws
  - vendor/katalog/dr/velero/velero-schedules
```

More information about [velero schedules](https://github.com/vmware-tanzu/velero/blob/master/site/docs/master/api-types/schedule.md)

### Snapshot Controller

The [`snapshot-controller`](./snapshot-controller/) module enables [CSI Snapshot Data Movement](https://velero.io/docs/main/csi-snapshot-data-movement/) support and is specifically designed to move **CSI snapshot data** to a backup storage location.

It requires requires a **CSI driver** to be installed on the underlying infrastructure, as **Velero** will use it to perform the data movement.

Example `kustomization.yaml` file

```yaml
namespace: kube-system

bases:
  - vendor/katalog/dr/velero/velero-base
  - vendor/katalog/dr/velero/velero-on-prem
  - vendor/katalog/dr/velero/snapshot-controller
```

<!-- </SD-DOCS> -->
