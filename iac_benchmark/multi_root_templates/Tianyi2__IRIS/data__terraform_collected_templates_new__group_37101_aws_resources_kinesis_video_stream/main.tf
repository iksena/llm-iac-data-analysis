resource "aws_kinesis_video_stream" "this" {
  name                    = var.name
  data_retention_in_hours = var.data_retention_in_hours
  device_name             = var.device_name
  kms_key_id              = var.kms_key_id
  media_type              = var.media_type

  tags = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}