/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

terraform {
  backend "gcs" {}
  required_version = "~> 1.4"
  required_providers {
    google = "~> 7.0"
    random = "~> 3.5.1"
  }
}

variable "gcp_project" {}
variable "my_cluster_name" {}
variable "environment" {
  default = "testing"
}

resource "random_id" "random_role_id_suffix" {
  byte_length = 2
}

module "velero" {
  source                   = "../../modules/gcp-velero"
  backup_bucket_name       = "${var.my_cluster_name}-${var.environment}-velero"
  gcp_service_account_name = "${var.my_cluster_name}-${var.environment}-velero"
  gcp_custom_role_name     = replace("${var.my_cluster_name}-${var.environment}-${random_id.random_role_id_suffix.hex}", "-", "_")
  project                  = var.gcp_project
}

output "cloud_credentials" {
  value     = module.velero.cloud_credentials
  sensitive = true
}

output "backup_storage_location" {
  value     = module.velero.backup_storage_location
  sensitive = true
}

output "volume_snapshot_location" {
  value     = module.velero.volume_snapshot_location
  sensitive = true
}
