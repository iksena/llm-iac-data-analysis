output "id" {
  description = "The Amazon Chime Voice Connector ID."
  value       = aws_chime_voice_connector_logging.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_chime_voice_connector_logging.this.region
}

output "voice_connector_id" {
  description = "The Amazon Chime Voice Connector ID."
  value       = aws_chime_voice_connector_logging.this.voice_connector_id
}

output "enable_sip_logs" {
  description = "Whether SIP message logs are enabled for sending to Amazon CloudWatch Logs."
  value       = aws_chime_voice_connector_logging.this.enable_sip_logs
}

output "enable_media_metric_logs" {
  description = "Whether logging of detailed media metrics for Voice Connectors to Amazon CloudWatch logs is enabled."
  value       = aws_chime_voice_connector_logging.this.enable_media_metric_logs
}