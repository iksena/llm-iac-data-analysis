resource "aws_dataexchange_event_action" "this" {
  region = var.region

  action {
    export_revision_to_s3 {
      dynamic "encryption" {
        for_each = var.encryption != null ? [var.encryption] : []
        content {
          type        = encryption.value.type
          kms_key_arn = encryption.value.kms_key_arn
        }
      }

      revision_destination {
        bucket      = var.revision_destination_bucket
        key_pattern = var.revision_destination_key_pattern
      }
    }
  }

  event {
    revision_published {
      data_set_id = var.data_set_id
    }
  }
}