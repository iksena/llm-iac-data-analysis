output "arn" {
  description = "Event source mapping ARN"
  value       = aws_lambda_event_source_mapping.this.arn
}

output "function_arn" {
  description = "ARN of the Lambda function the event source mapping is sending events to"
  value       = aws_lambda_event_source_mapping.this.function_arn
}

output "last_modified" {
  description = "Date this resource was last modified"
  value       = aws_lambda_event_source_mapping.this.last_modified
}

output "last_processing_result" {
  description = "Result of the last AWS Lambda invocation of your Lambda function"
  value       = aws_lambda_event_source_mapping.this.last_processing_result
}

output "state" {
  description = "State of the event source mapping"
  value       = aws_lambda_event_source_mapping.this.state
}

output "state_transition_reason" {
  description = "Reason the event source mapping is in its current state"
  value       = aws_lambda_event_source_mapping.this.state_transition_reason
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lambda_event_source_mapping.this.tags_all
}

output "uuid" {
  description = "UUID of the created event source mapping"
  value       = aws_lambda_event_source_mapping.this.uuid
}