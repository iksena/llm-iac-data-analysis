output "application_id" {
  description = "The application ID"
  value       = aws_pinpoint_apns_voip_sandbox_channel.this.application_id
}

output "enabled" {
  description = "Whether the channel is enabled or disabled"
  value       = aws_pinpoint_apns_voip_sandbox_channel.this.enabled
}

output "default_authentication_method" {
  description = "The default authentication method used for APNs"
  value       = aws_pinpoint_apns_voip_sandbox_channel.this.default_authentication_method
}