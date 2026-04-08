output "arn" {
  description = "ARN of the configuration set."
  value       = aws_pinpointsmsvoicev2_configuration_set.this.arn
}

output "name" {
  description = "The name of the configuration set."
  value       = aws_pinpointsmsvoicev2_configuration_set.this.name
}

output "default_sender_id" {
  description = "The default sender ID to use for this configuration set."
  value       = aws_pinpointsmsvoicev2_configuration_set.this.default_sender_id
}

output "default_message_type" {
  description = "The default message type."
  value       = aws_pinpointsmsvoicev2_configuration_set.this.default_message_type
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_pinpointsmsvoicev2_configuration_set.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_pinpointsmsvoicev2_configuration_set.this.tags_all
}