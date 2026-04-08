output "arn" {
  description = "The ARN of the backup report plan."
  value       = aws_backup_report_plan.this.arn
}

output "creation_time" {
  description = "The date and time that a report plan is created, in Unix format and Coordinated Universal Time (UTC)."
  value       = aws_backup_report_plan.this.creation_time
}

output "deployment_status" {
  description = "The deployment status of a report plan. The statuses are: CREATE_IN_PROGRESS | UPDATE_IN_PROGRESS | DELETE_IN_PROGRESS | COMPLETED."
  value       = aws_backup_report_plan.this.deployment_status
}

output "id" {
  description = "The id of the backup report plan."
  value       = aws_backup_report_plan.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_backup_report_plan.this.tags_all
}