resource "aws_s3_bucket_metadata_configuration" "this" {
  bucket = var.bucket
  region = var.region

  metadata_configuration {
    inventory_table_configuration {
      configuration_state = var.metadata_configuration.inventory_table_configuration.configuration_state

      dynamic "encryption_configuration" {
        for_each = var.metadata_configuration.inventory_table_configuration.encryption_configuration != null ? [var.metadata_configuration.inventory_table_configuration.encryption_configuration] : []
        content {
          sse_algorithm = encryption_configuration.value.sse_algorithm
          kms_key_arn   = encryption_configuration.value.kms_key_arn
        }
      }
    }

    journal_table_configuration {
      dynamic "encryption_configuration" {
        for_each = var.metadata_configuration.journal_table_configuration.encryption_configuration != null ? [var.metadata_configuration.journal_table_configuration.encryption_configuration] : []
        content {
          sse_algorithm = encryption_configuration.value.sse_algorithm
          kms_key_arn   = encryption_configuration.value.kms_key_arn
        }
      }

      record_expiration {
        days       = var.metadata_configuration.journal_table_configuration.record_expiration.days
        expiration = var.metadata_configuration.journal_table_configuration.record_expiration.expiration
      }
    }
  }

  timeouts {
    create = var.timeouts.create
  }
}