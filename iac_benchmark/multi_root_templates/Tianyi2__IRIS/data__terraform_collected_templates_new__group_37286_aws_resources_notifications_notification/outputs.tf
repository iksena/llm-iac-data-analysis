output "arn" {
  description = "Amazon Resource Name (ARN) of the NotificationConfiguration."
  value       = aws_notifications_notification_configuration.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_notifications_notification_configuration.this.tags_all
}