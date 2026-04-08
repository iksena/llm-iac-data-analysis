output "arn" {
  description = "ARN of the channel associated with the notification configuration."
  value       = aws_notifications_channel_association.this.arn
}

output "notification_configuration_arn" {
  description = "ARN of the notification configuration associated with the channel."
  value       = aws_notifications_channel_association.this.notification_configuration_arn
}