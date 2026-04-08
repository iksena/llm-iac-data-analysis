output "arn" {
  description = "ARN of the backup framework."
  value       = data.aws_backup_framework.this.arn
}

output "control" {
  description = "One or more control blocks that make up the framework. Each control in the list has a name, input parameters, and scope."
  value       = data.aws_backup_framework.this.control
}

output "creation_time" {
  description = "Date and time that a framework is created, in Unix format and Coordinated Universal Time (UTC)."
  value       = data.aws_backup_framework.this.creation_time
}

output "deployment_status" {
  description = "Deployment status of a framework. The statuses are: CREATE_IN_PROGRESS | UPDATE_IN_PROGRESS | DELETE_IN_PROGRESS | COMPLETED| FAILED."
  value       = data.aws_backup_framework.this.deployment_status
}

output "description" {
  description = "Description of the framework."
  value       = data.aws_backup_framework.this.description
}

output "id" {
  description = "ID of the framework."
  value       = data.aws_backup_framework.this.id
}

output "status" {
  description = "Framework consists of one or more controls. Each control governs a resource, such as backup plans, backup selections, backup vaults, or recovery points. You can also turn AWS Config recording on or off for each resource. The statuses are: ACTIVE, PARTIALLY_ACTIVE, INACTIVE, UNAVAILABLE."
  value       = data.aws_backup_framework.this.status
}

output "tags" {
  description = "Metadata that helps organize the frameworks you create."
  value       = data.aws_backup_framework.this.tags
}