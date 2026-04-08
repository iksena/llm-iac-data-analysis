output "arn" {
  description = "ARN of the ECS Service"
  value       = data.aws_ecs_service.this.arn
}

output "desired_count" {
  description = "Number of tasks for the ECS Service"
  value       = data.aws_ecs_service.this.desired_count
}

output "launch_type" {
  description = "Launch type for the ECS Service"
  value       = data.aws_ecs_service.this.launch_type
}

output "load_balancer" {
  description = "Load balancers for the ECS Service"
  value       = data.aws_ecs_service.this.load_balancer
}

output "scheduling_strategy" {
  description = "Scheduling strategy for the ECS Service"
  value       = data.aws_ecs_service.this.scheduling_strategy
}

output "task_definition" {
  description = "Family for the latest ACTIVE revision or full ARN of the task definition"
  value       = data.aws_ecs_service.this.task_definition
}

output "tags" {
  description = "Resource tags"
  value       = data.aws_ecs_service.this.tags
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ecs_service.this.region
}

output "service_name" {
  description = "Name of the ECS Service"
  value       = data.aws_ecs_service.this.service_name
}

output "cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = data.aws_ecs_service.this.cluster_arn
}