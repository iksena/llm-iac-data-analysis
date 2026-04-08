output "arn" {
  description = "ARN that identifies the cluster"
  value       = aws_ecs_cluster.this.arn
}

output "name" {
  description = "Name of the cluster"
  value       = aws_ecs_cluster.this.name
}

output "region" {
  description = "Region where the cluster is managed"
  value       = aws_ecs_cluster.this.region
}

output "configuration" {
  description = "Execute command configuration for the cluster"
  value       = aws_ecs_cluster.this.configuration
}

output "service_connect_defaults" {
  description = "Default Service Connect namespace"
  value       = aws_ecs_cluster.this.service_connect_defaults
}

output "setting" {
  description = "Configuration blocks with cluster settings"
  value       = aws_ecs_cluster.this.setting
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = aws_ecs_cluster.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ecs_cluster.this.tags_all
}