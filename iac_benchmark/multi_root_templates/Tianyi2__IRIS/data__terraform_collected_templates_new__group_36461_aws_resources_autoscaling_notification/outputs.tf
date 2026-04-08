output "group_names" {
  description = "List of AutoScaling Group Names"
  value       = aws_autoscaling_notification.this.group_names
}

output "notifications" {
  description = "List of Notification Types that trigger notifications"
  value       = aws_autoscaling_notification.this.notifications
}

output "topic_arn" {
  description = "Topic ARN for notifications to be sent through"
  value       = aws_autoscaling_notification.this.topic_arn
}