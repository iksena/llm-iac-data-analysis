output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "ecs_service_arn" {
  value = aws_ecs_service.this.id
}

output "deployment_permission_set" {
  description = "Minimal requirements required to deploy the service using AWS Actions"
  value       = data.aws_iam_policy_document.deployment_requirements
}
