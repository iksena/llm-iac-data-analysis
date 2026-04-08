resource "aws_evidently_project" "this" {
  region      = var.region
  name        = var.name
  description = var.description

  dynamic "data_delivery" {
    for_each = var.data_delivery != null ? [var.data_delivery] : []
    content {
      dynamic "cloudwatch_logs" {
        for_each = data_delivery.value.cloudwatch_logs != null ? [data_delivery.value.cloudwatch_logs] : []
        content {
          log_group = cloudwatch_logs.value.log_group
        }
      }

      dynamic "s3_destination" {
        for_each = data_delivery.value.s3_destination != null ? [data_delivery.value.s3_destination] : []
        content {
          bucket = s3_destination.value.bucket
          prefix = s3_destination.value.prefix
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}