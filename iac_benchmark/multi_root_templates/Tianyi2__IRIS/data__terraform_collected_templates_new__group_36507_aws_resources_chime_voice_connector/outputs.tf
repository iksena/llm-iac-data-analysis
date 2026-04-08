output "arn" {
  description = "ARN (Amazon Resource Name) of the Amazon Chime Voice Connector."
  value       = aws_chime_voice_connector.this.arn
}

output "outbound_host_name" {
  description = "The outbound host name for the Amazon Chime Voice Connector."
  value       = aws_chime_voice_connector.this.outbound_host_name
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_chime_voice_connector.this.tags_all
}