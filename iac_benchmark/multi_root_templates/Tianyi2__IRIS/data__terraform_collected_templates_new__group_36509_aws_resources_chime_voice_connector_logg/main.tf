resource "aws_chime_voice_connector_logging" "this" {
  region                   = var.region
  voice_connector_id       = var.voice_connector_id
  enable_sip_logs          = var.enable_sip_logs
  enable_media_metric_logs = var.enable_media_metric_logs
}