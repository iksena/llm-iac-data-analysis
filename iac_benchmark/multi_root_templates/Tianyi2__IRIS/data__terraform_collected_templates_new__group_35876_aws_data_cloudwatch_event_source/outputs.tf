output "arn" {
  description = "ARN of the partner event source"
  value       = data.aws_cloudwatch_event_source.this.arn
}

output "created_by" {
  description = "Name of the SaaS partner that created the event source"
  value       = data.aws_cloudwatch_event_source.this.created_by
}

output "name" {
  description = "Name of the event source"
  value       = data.aws_cloudwatch_event_source.this.name
}

output "state" {
  description = "State of the event source (ACTIVE or PENDING)"
  value       = data.aws_cloudwatch_event_source.this.state
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_cloudwatch_event_source.this.region
}

output "name_prefix" {
  description = "Name prefix used to filter partner event sources"
  value       = var.name_prefix
}