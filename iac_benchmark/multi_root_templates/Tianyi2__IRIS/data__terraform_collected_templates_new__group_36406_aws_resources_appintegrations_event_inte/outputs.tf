output "arn" {
  description = "ARN of the Event Integration"
  value       = aws_appintegrations_event_integration.this.arn
}

output "id" {
  description = "Identifier of the Event Integration which is the name of the Event Integration"
  value       = aws_appintegrations_event_integration.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_appintegrations_event_integration.this.tags_all
}