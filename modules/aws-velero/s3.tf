/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "aws_s3_bucket" "backup_bucket" {
  bucket        = var.backup_bucket_name
  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_acl" "backup_bucket_acl" {
  bucket = aws_s3_bucket.backup_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "backup_bucket_versioning" {
  bucket = aws_s3_bucket.backup_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup_bucket_encryption_configuration" {
  bucket = aws_s3_bucket.backup_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}