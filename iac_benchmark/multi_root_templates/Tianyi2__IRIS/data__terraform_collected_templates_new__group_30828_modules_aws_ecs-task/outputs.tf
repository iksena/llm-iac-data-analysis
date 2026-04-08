output "arn" {
  value = aws_ecs_task_definition.task-definition.arn
}

output "name" {
  value = var.task_name
}
