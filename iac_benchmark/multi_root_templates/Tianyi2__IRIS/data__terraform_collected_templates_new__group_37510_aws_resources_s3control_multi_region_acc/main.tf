resource "aws_s3control_multi_region_access_point" "this" {
  region     = var.region
  account_id = var.account_id

  details {
    name = var.details.name

    dynamic "public_access_block" {
      for_each = var.details.public_access_block != null ? [var.details.public_access_block] : []
      content {
        block_public_acls       = public_access_block.value.block_public_acls
        block_public_policy     = public_access_block.value.block_public_policy
        ignore_public_acls      = public_access_block.value.ignore_public_acls
        restrict_public_buckets = public_access_block.value.restrict_public_buckets
      }
    }

    dynamic "region" {
      for_each = var.details.regions
      content {
        bucket            = region.value.bucket
        bucket_account_id = region.value.bucket_account_id
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}