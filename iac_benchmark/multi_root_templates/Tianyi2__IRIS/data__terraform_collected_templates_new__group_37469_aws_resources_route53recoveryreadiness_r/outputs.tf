output "arn" {
  description = "ARN of the resource set"
  value       = aws_route53recoveryreadiness_resource_set.this.arn
}

output "resource_set_name" {
  description = "Name of the resource set"
  value       = aws_route53recoveryreadiness_resource_set.this.resource_set_name
}

output "resource_set_type" {
  description = "Type of the resources in the resource set"
  value       = aws_route53recoveryreadiness_resource_set.this.resource_set_type
}

output "resources" {
  description = "List of resources in the resource set with their component IDs"
  value       = aws_route53recoveryreadiness_resource_set.this.resources
}

output "component_ids" {
  description = "List of unique identifiers for DNS Target Resources, use for readiness checks"
  value       = [for resource in aws_route53recoveryreadiness_resource_set.this.resources : resource.component_id if can(resource.component_id)]
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53recoveryreadiness_resource_set.this.tags_all
}