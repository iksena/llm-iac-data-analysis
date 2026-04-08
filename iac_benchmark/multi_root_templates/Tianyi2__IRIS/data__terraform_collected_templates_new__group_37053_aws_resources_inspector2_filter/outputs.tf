output "arn" {
  description = "ARN of the Filter"
  value       = aws_inspector2_filter.this.arn
}

output "name" {
  description = "Name of the filter"
  value       = aws_inspector2_filter.this.name
}

output "action" {
  description = "Action to be applied to the findings that match the filter"
  value       = aws_inspector2_filter.this.action
}

output "description" {
  description = "Description of the filter"
  value       = aws_inspector2_filter.this.description
}

output "reason" {
  description = "Reason for creating the filter"
  value       = aws_inspector2_filter.this.reason
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_inspector2_filter.this.region
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = aws_inspector2_filter.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_inspector2_filter.this.tags_all
}