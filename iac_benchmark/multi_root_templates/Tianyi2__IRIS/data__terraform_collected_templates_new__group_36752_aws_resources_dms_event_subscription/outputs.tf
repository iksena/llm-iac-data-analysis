output "arn" {
  description = "Amazon Resource Name (ARN) of the DMS Event Subscription."
  value       = aws_dms_event_subscription.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dms_event_subscription.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_dms_event_subscription.this.region
}

output "name" {
  description = "Name of event subscription."
  value       = aws_dms_event_subscription.this.name
}

output "enabled" {
  description = "Whether the event subscription is enabled."
  value       = aws_dms_event_subscription.this.enabled
}

output "event_categories" {
  description = "List of event categories being listened for."
  value       = aws_dms_event_subscription.this.event_categories
}

output "sns_topic_arn" {
  description = "SNS topic arn to send events on."
  value       = aws_dms_event_subscription.this.sns_topic_arn
}

output "source_ids" {
  description = "Ids of sources being listened to."
  value       = aws_dms_event_subscription.this.source_ids
}

output "source_type" {
  description = "Type of source for events."
  value       = aws_dms_event_subscription.this.source_type
}

output "tags" {
  description = "Map of resource tags assigned to the resource."
  value       = aws_dms_event_subscription.this.tags
}