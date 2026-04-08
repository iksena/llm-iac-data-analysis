resource "aws_connect_instance_storage_config" "this" {
  region        = var.region
  instance_id   = var.instance_id
  resource_type = var.resource_type

  storage_config {
    storage_type = var.storage_config.storage_type

    dynamic "kinesis_firehose_config" {
      for_each = var.storage_config.kinesis_firehose_config != null ? [var.storage_config.kinesis_firehose_config] : []
      content {
        firehose_arn = kinesis_firehose_config.value.firehose_arn
      }
    }

    dynamic "kinesis_stream_config" {
      for_each = var.storage_config.kinesis_stream_config != null ? [var.storage_config.kinesis_stream_config] : []
      content {
        stream_arn = kinesis_stream_config.value.stream_arn
      }
    }

    dynamic "kinesis_video_stream_config" {
      for_each = var.storage_config.kinesis_video_stream_config != null ? [var.storage_config.kinesis_video_stream_config] : []
      content {
        prefix                 = kinesis_video_stream_config.value.prefix
        retention_period_hours = kinesis_video_stream_config.value.retention_period_hours
        encryption_config {
          encryption_type = kinesis_video_stream_config.value.encryption_config.encryption_type
          key_id          = kinesis_video_stream_config.value.encryption_config.key_id
        }
      }
    }

    dynamic "s3_config" {
      for_each = var.storage_config.s3_config != null ? [var.storage_config.s3_config] : []
      content {
        bucket_name   = s3_config.value.bucket_name
        bucket_prefix = s3_config.value.bucket_prefix
        encryption_config {
          encryption_type = s3_config.value.encryption_config.encryption_type
          key_id          = s3_config.value.encryption_config.key_id
        }
      }
    }
  }
}