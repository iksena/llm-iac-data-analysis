output "arn" {
  description = "ARN of the ECS Cluster"
  value       = data.aws_ecs_cluster.this.arn
}

output "status" {
  description = "Status of the ECS Cluster"
  value       = data.aws_ecs_cluster.this.status
}

output "pending_tasks_count" {
  description = "Number of pending tasks for the ECS Cluster"
  value       = data.aws_ecs_cluster.this.pending_tasks_count
}

output "running_tasks_count" {
  description = "Number of running tasks for the ECS Cluster"
  value       = data.aws_ecs_cluster.this.running_tasks_count
}

output "registered_container_instances_count" {
  description = "The number of registered container instances for the ECS Cluster"
  value       = data.aws_ecs_cluster.this.registered_container_instances_count
}

output "service_connect_defaults" {
  description = "The default Service Connect namespace"
  value       = data.aws_ecs_cluster.this.service_connect_defaults
}

output "setting" {
  description = "Settings associated with the ECS Cluster"
  value       = data.aws_ecs_cluster.this.setting
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = data.aws_ecs_cluster.this.tags
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ecs_cluster.this.region
}

output "cluster_name" {
  description = "Name of the ECS Cluster"
  value       = data.aws_ecs_cluster.this.cluster_name
}