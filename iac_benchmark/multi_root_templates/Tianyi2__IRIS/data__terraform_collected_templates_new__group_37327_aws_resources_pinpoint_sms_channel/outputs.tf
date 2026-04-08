output "region" {
  description = "Region where this resource is managed."
  value       = aws_pinpoint_sms_channel.this.region
}

output "application_id" {
  description = "ID of the application."
  value       = aws_pinpoint_sms_channel.this.application_id
}

output "enabled" {
  description = "Whether the channel is enabled or disabled."
  value       = aws_pinpoint_sms_channel.this.enabled
}

output "sender_id" {
  description = "Identifier of the sender for your messages."
  value       = aws_pinpoint_sms_channel.this.sender_id
}

output "short_code" {
  description = "Short Code registered with the phone provider."
  value       = aws_pinpoint_sms_channel.this.short_code
}

output "promotional_messages_per_second" {
  description = "Maximum number of promotional messages that can be sent per second."
  value       = aws_pinpoint_sms_channel.this.promotional_messages_per_second
}

output "transactional_messages_per_second" {
  description = "Maximum number of transactional messages per second that can be sent."
  value       = aws_pinpoint_sms_channel.this.transactional_messages_per_second
}