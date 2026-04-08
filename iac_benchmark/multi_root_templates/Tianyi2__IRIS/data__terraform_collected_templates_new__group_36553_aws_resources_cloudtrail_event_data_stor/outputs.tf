output "arn" {
  description = "ARN of the event data store"
  value       = aws_cloudtrail_event_data_store.this.arn
}

output "id" {
  description = "Name of the event data store"
  value       = aws_cloudtrail_event_data_store.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cloudtrail_event_data_store.this.tags_all
}