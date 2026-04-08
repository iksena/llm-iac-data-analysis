output "arn" {
  description = "ARN of the event bus."
  value       = aws_cloudwatch_event_bus.this.arn
}

output "id" {
  description = "Name of the event bus."
  value       = aws_cloudwatch_event_bus.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudwatch_event_bus.this.tags_all
}