output "arn" {
  description = "ARN of the event bus"
  value       = data.aws_cloudwatch_event_bus.this.arn
}

output "dead_letter_config" {
  description = "Configuration details of the Amazon SQS queue for EventBridge to use as a dead-letter queue (DLQ)"
  value       = data.aws_cloudwatch_event_bus.this.dead_letter_config
}

output "description" {
  description = "Event bus description"
  value       = data.aws_cloudwatch_event_bus.this.description
}

output "id" {
  description = "Name of the event bus"
  value       = data.aws_cloudwatch_event_bus.this.id
}

output "kms_key_identifier" {
  description = "Identifier of the AWS KMS customer managed key for EventBridge to use to encrypt events on this event bus"
  value       = data.aws_cloudwatch_event_bus.this.kms_key_identifier
}

output "log_config" {
  description = "Block for logging configuration settings for the event bus"
  value       = data.aws_cloudwatch_event_bus.this.log_config
}