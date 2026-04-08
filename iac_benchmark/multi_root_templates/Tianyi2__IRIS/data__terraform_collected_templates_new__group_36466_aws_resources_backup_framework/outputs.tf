output "arn" {
  description = "The ARN of the backup framework."
  value       = aws_backup_framework.this.arn
}

output "creation_time" {
  description = "The date and time that a framework is created, in Unix format and Coordinated Universal Time (UTC)."
  value       = aws_backup_framework.this.creation_time
}

output "deployment_status" {
  description = "The deployment status of a framework. The statuses are: CREATE_IN_PROGRESS | UPDATE_IN_PROGRESS | DELETE_IN_PROGRESS | COMPLETED | FAILED."
  value       = aws_backup_framework.this.deployment_status
}

output "id" {
  description = "The id of the backup framework."
  value       = aws_backup_framework.this.id
}

output "status" {
  description = "A framework consists of one or more controls. Each control governs a resource, such as backup plans, backup selections, backup vaults, or recovery points."
  value       = aws_backup_framework.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_backup_framework.this.tags_all
}