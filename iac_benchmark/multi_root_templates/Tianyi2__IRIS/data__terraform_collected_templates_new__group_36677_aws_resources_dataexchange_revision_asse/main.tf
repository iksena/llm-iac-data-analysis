resource "aws_dataexchange_revision_assets" "this" {
  data_set_id = var.data_set_id

  dynamic "asset" {
    for_each = var.asset
    content {
      dynamic "create_s3_data_access_from_s3_bucket" {
        for_each = asset.value.create_s3_data_access_from_s3_bucket != null ? [asset.value.create_s3_data_access_from_s3_bucket] : []
        content {
          asset_source {
            bucket       = create_s3_data_access_from_s3_bucket.value.asset_source.bucket
            keys         = create_s3_data_access_from_s3_bucket.value.asset_source.keys
            key_prefixes = create_s3_data_access_from_s3_bucket.value.asset_source.key_prefixes
          }
        }
      }

      dynamic "import_assets_from_s3" {
        for_each = asset.value.import_assets_from_s3 != null ? [asset.value.import_assets_from_s3] : []
        content {
          asset_source {
            bucket = import_assets_from_s3.value.asset_source.bucket
            key    = import_assets_from_s3.value.asset_source.key
          }
        }
      }

      dynamic "import_assets_from_signed_url" {
        for_each = asset.value.import_assets_from_signed_url != null ? [asset.value.import_assets_from_signed_url] : []
        content {
          filename = import_assets_from_signed_url.value.filename
        }
      }
    }
  }

  region        = var.region
  comment       = var.comment
  finalized     = var.finalize
  force_destroy = var.force_destroy
  tags          = var.tags

  timeouts {
    create = "30m"
  }
}