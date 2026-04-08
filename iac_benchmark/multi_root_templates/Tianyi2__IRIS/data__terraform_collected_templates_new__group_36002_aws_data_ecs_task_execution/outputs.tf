output "task_arns" {
  description = "A list of the provisioned task ARNs."
  value       = data.aws_ecs_task_execution.this.task_arns
}

output "id" {
  description = "The unique identifier, which is a comma-delimited string joining the cluster and task_definition attributes."
  value       = data.aws_ecs_task_execution.this.id
}