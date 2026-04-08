resource "aws_verifiedaccess_instance_logging_configuration" "this" {
  verifiedaccess_instance_id = var.verifiedaccess_instance_id

  access_logs {
    include_trust_context = var.include_trust_context
    log_version           = var.log_version

    dynamic "cloudwatch_logs" {
      for_each = var.cloudwatch_logs != null ? [var.cloudwatch_logs] : []
      content {
        enabled   = cloudwatch_logs.value.enabled
        log_group = cloudwatch_logs.value.log_group
      }
    }

    dynamic "kinesis_data_firehose" {
      for_each = var.kinesis_data_firehose != null ? [var.kinesis_data_firehose] : []
      content {
        enabled         = kinesis_data_firehose.value.enabled
        delivery_stream = kinesis_data_firehose.value.delivery_stream
      }
    }

    dynamic "s3" {
      for_each = var.s3 != null ? [var.s3] : []
      content {
        enabled      = s3.value.enabled
        bucket_name  = s3.value.bucket_name
        bucket_owner = s3.value.bucket_owner
        prefix       = s3.value.prefix
      }
    }
  }
}