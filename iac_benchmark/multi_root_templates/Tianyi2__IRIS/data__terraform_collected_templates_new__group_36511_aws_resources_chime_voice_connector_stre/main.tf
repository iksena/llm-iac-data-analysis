resource "aws_chime_voice_connector_streaming" "this" {
  region                         = var.region
  voice_connector_id             = var.voice_connector_id
  data_retention                 = var.data_retention
  disabled                       = var.disabled
  streaming_notification_targets = var.streaming_notification_targets

  dynamic "media_insights_configuration" {
    for_each = var.media_insights_configuration != null ? [var.media_insights_configuration] : []
    content {
      disabled          = media_insights_configuration.value.disabled
      configuration_arn = media_insights_configuration.value.configuration_arn
    }
  }
}