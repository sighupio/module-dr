# AWS Velero

**This Terraform module generates the AWS cloud resources (S3 and IAM) required by Velero to back up Kubernetes objects and trigger volume snapshots.**

> [!NOTE]
> This module is part of [SIGHUP Distribution (SD)](https://github.com/sighupio/distribution) and is consumed automatically by `furyctl` when you create a cluster. You don't need to use it directly: its inputs are derived from your `furyctl.yaml`. The reference below is intended for maintainers and contributors.

## Requirements

|   Name    | Version  |
| --------- | -------- |
| terraform | `0.15.4` |
| aws       | `3.37.0` |

## Providers

| Name | Version  |
| ---- | -------- |
| aws  | `3.37.0` |

## Resources

|                                                                          Name                                                                          |    Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_iam_access_key.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_access_key)                         | resource    |
| [aws_iam_policy.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_policy)                                 | resource    |
| [aws_iam_policy_attachment.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_policy_attachment)           | resource    |
| [aws_iam_role.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.velero_backup](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_user.velero_backup_user](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/iam_user)                                | resource    |
| [aws_s3_bucket.backup_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/resources/s3_bucket)                                   | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.37.0/docs/data-sources/caller_identity)                          | data source |

## Inputs

|         Name         |              Description              |     Type      | Default | Required |
| -------------------- | ------------------------------------- | ------------- | ------- | :------: |
| backup\_bucket\_name | Backup Bucket Name                    | `string`      | n/a     |   yes    |
| oidc\_provider\_url  | URL of OIDC issuer discovery document | `string`      | `""`    |    no    |
| tags                 | Custom tags to apply to resources     | `map(string)` | `{}`    |    no    |

## Outputs

|            Name            |               Description               |
| -------------------------- | --------------------------------------- |
| backup\_storage\_location  | Velero Cloud BackupStorageLocation CRD  |
| cloud\_credentials         | Velero required file with credentials   |
| service\_account           | Velero ServiceAccount                   |
| volume\_snapshot\_location | Velero Cloud VolumeSnapshotLocation CRD |
