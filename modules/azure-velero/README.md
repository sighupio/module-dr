# Azure Velero

**This Terraform module generates the Azure cloud resources (Object Storage and credentials) required by Velero to back up Kubernetes objects and trigger volume snapshots.**

> [!NOTE]
> This module is part of [SIGHUP Distribution (SD)](https://github.com/sighupio/distribution) and is consumed automatically by `furyctl` when you create a cluster. You don't need to use it directly: its inputs are derived from your `furyctl.yaml`. The reference below is intended for maintainers and contributors.

## Providers

This module is compatible with `azurerm` terraform provider version:
[`1.44.0`](https://github.com/terraform-providers/terraform-provider-azurerm/tree/v1.44.0)

## Inputs

| Name                          | Description                                                                                                      | Type          | Default              | Required |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------- | -------------------- | :------: |
| aks\_resource\_group\_name    | Resource group name of AKS cluster to backup                                                                     | `string`      | n/a                  |   yes    |
| azure\_cloud\_name            | available azure\_cloud\_name values: AzurePublicCloud, AzureUSGovernmentCloud, AzureChinaCloud, AzureGermanCloud | `string`      | `"AzurePublicCloud"` |   no     |
| backup\_bucket\_name          | Backup Bucket Name                                                                                               | `string`      | n/a                  |   yes    |
| velero\_resource\_group\_name | Resouce group in which to create velero resources                                                                | `string`      | n/a                  |   yes    |
| tags                          | Custom tags to apply to resources                                                                                | `map(string)` | `{}`                 |   no     |

## Outputs

| Name                       | Description                             |
| -------------------------- | --------------------------------------- |
| backup\_storage\_location  | Velero Cloud BackupStorageLocation CRD  |
| cloud\_credentials         | Velero required file with credentials   |
| volume\_snapshot\_location | Velero Cloud VolumeSnapshotLocation CRD |
