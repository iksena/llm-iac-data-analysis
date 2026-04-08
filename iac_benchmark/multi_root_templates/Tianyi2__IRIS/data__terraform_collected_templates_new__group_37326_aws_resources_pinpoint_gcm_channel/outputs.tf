output "application_id" {
  description = "The application ID"
  value       = aws_pinpoint_gcm_channel.this.application_id
}

output "enabled" {
  description = "Whether the channel is enabled or disabled"
  value       = aws_pinpoint_gcm_channel.this.enabled
}