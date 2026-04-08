output "arn" {
  description = "ARN that identifies the capacity provider"
  value       = aws_ecs_capacity_provider.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ecs_capacity_provider.this.tags_all
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ecs_capacity_provider.this.region
}

output "name" {
  description = "Name of the capacity provider"
  value       = aws_ecs_capacity_provider.this.name
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = aws_ecs_capacity_provider.this.tags
}

output "auto_scaling_group_provider" {
  description = "Configuration block for the provider for the ECS auto scaling group"
  value       = aws_ecs_capacity_provider.this.auto_scaling_group_provider
}