resource "aws_ivs_recording_configuration" "this" {
  name                               = var.name
  region                             = var.region
  recording_reconnect_window_seconds = var.recording_reconnect_window_seconds
  tags                               = var.tags

  destination_configuration {
    s3 {
      bucket_name = var.destination_configuration_s3_bucket_name
    }
  }

  dynamic "thumbnail_configuration" {
    for_each = var.thumbnail_configuration != null ? [var.thumbnail_configuration] : []
    content {
      recording_mode          = thumbnail_configuration.value.recording_mode
      target_interval_seconds = thumbnail_configuration.value.target_interval_seconds
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}