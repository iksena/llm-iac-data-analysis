resource "aws_ivschat_logging_configuration" "this" {
  dynamic "destination_configuration" {
    for_each = var.destination_configuration != null ? [var.destination_configuration] : []
    content {
      dynamic "cloudwatch_logs" {
        for_each = destination_configuration.value.cloudwatch_logs != null ? [destination_configuration.value.cloudwatch_logs] : []
        content {
          log_group_name = cloudwatch_logs.value.log_group_name
        }
      }

      dynamic "firehose" {
        for_each = destination_configuration.value.firehose != null ? [destination_configuration.value.firehose] : []
        content {
          delivery_stream_name = firehose.value.delivery_stream_name
        }
      }

      dynamic "s3" {
        for_each = destination_configuration.value.s3 != null ? [destination_configuration.value.s3] : []
        content {
          bucket_name = s3.value.bucket_name
        }
      }
    }
  }

  region = var.region
  name   = var.name
  tags   = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}