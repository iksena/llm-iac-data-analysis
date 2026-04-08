output "id" {
  description = "The ID of the APNs VoIP channel (same as application_id)"
  value       = aws_pinpoint_apns_voip_channel.this.id
}

output "application_id" {
  description = "The application ID"
  value       = aws_pinpoint_apns_voip_channel.this.application_id
}