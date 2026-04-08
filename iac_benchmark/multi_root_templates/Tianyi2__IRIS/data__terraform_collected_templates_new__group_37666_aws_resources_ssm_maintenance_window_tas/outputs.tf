output "arn" {
  description = "The ARN of the maintenance window task"
  value       = aws_ssm_maintenance_window_task.this.arn
}

output "id" {
  description = "The ID of the maintenance window task"
  value       = aws_ssm_maintenance_window_task.this.id
}

output "window_task_id" {
  description = "The ID of the maintenance window task"
  value       = aws_ssm_maintenance_window_task.this.window_task_id
}