output "id" {
  description = "Unique identifier for the notification channel."
  value       = data.aws_devopsguru_notification_channel.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_devopsguru_notification_channel.this.region
}

output "filters" {
  description = "Filter configurations for the Amazon SNS notification topic."
  value       = data.aws_devopsguru_notification_channel.this.filters
}

output "sns" {
  description = "SNS notification channel configurations."
  value       = data.aws_devopsguru_notification_channel.this.sns
}