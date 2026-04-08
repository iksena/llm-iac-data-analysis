resource "aws_appfabric_ingestion_destination" "this" {
  region         = var.region
  app_bundle_arn = var.app_bundle_arn
  ingestion_arn  = var.ingestion_arn
  tags           = var.tags

  destination_configuration {
    audit_log {
      destination {
        dynamic "firehose_stream" {
          for_each = var.destination_configuration.audit_log.destination.firehose_stream != null ? [1] : []
          content {
            stream_name = var.destination_configuration.audit_log.destination.firehose_stream.streamName
          }
        }

        dynamic "s3_bucket" {
          for_each = var.destination_configuration.audit_log.destination.s3_bucket != null ? [1] : []
          content {
            bucket_name = var.destination_configuration.audit_log.destination.s3_bucket.bucketName
            prefix      = var.destination_configuration.audit_log.destination.s3_bucket.prefix
          }
        }
      }
    }
  }

  processing_configuration {
    audit_log {
      format = var.processing_configuration.audit_log.format
      schema = var.processing_configuration.audit_log.schema
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}