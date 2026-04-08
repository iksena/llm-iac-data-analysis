output "application_id" {
  description = "The application ID"
  value       = aws_pinpoint_adm_channel.this.application_id
}

output "enabled" {
  description = "Whether the channel is enabled"
  value       = aws_pinpoint_adm_channel.this.enabled
}