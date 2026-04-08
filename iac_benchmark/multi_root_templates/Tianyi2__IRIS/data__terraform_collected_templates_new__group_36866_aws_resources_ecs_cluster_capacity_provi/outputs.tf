output "id" {
  description = "Same as cluster_name."
  value       = aws_ecs_cluster_capacity_providers.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ecs_cluster_capacity_providers.this.region
}

output "capacity_providers" {
  description = "Set of names of capacity providers associated with the cluster."
  value       = aws_ecs_cluster_capacity_providers.this.capacity_providers
}

output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster_capacity_providers.this.cluster_name
}

output "default_capacity_provider_strategy" {
  description = "Set of capacity provider strategies used by default for the cluster."
  value       = aws_ecs_cluster_capacity_providers.this.default_capacity_provider_strategy
}