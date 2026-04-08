resource "aws_ebs_snapshot_import" "this" {
  region                 = var.region
  description            = var.description
  encrypted              = var.encrypted
  kms_key_id             = var.kms_key_id
  storage_tier           = var.storage_tier
  permanent_restore      = var.permanent_restore
  temporary_restore_days = var.temporary_restore_days
  role_name              = var.role_name
  tags                   = var.tags

  dynamic "client_data" {
    for_each = var.client_data != null ? [var.client_data] : []
    content {
      comment      = client_data.value.comment
      upload_start = client_data.value.upload_start
      upload_end   = client_data.value.upload_end
      upload_size  = client_data.value.upload_size
    }
  }

  disk_container {
    description = var.disk_container.description
    format      = var.disk_container.format
    url         = var.disk_container.url

    dynamic "user_bucket" {
      for_each = var.disk_container.user_bucket != null ? [var.disk_container.user_bucket] : []
      content {
        s3_bucket = user_bucket.value.s3_bucket
        s3_key    = user_bucket.value.s3_key
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}