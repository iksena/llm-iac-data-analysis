output "plan_id" {
  description = "Backup plan ID"
  value       = data.aws_backup_plan.this.plan_id
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_backup_plan.this.region
}

output "arn" {
  description = "ARN of the backup plan"
  value       = data.aws_backup_plan.this.arn
}

output "name" {
  description = "Display name of a backup plan"
  value       = data.aws_backup_plan.this.name
}

output "rule" {
  description = "Rules of a backup plan"
  value       = data.aws_backup_plan.this.rule
}

output "tags" {
  description = "Metadata that you can assign to help organize the plans you create"
  value       = data.aws_backup_plan.this.tags
}

output "version" {
  description = "Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan"
  value       = data.aws_backup_plan.this.version
}