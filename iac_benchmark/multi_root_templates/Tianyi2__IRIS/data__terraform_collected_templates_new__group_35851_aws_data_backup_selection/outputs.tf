output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_backup_selection.this.region
}

output "plan_id" {
  description = "Backup plan ID associated with the selection of resources."
  value       = data.aws_backup_selection.this.plan_id
}

output "selection_id" {
  description = "Backup selection ID."
  value       = data.aws_backup_selection.this.selection_id
}

output "name" {
  description = "Display name of a resource selection document."
  value       = data.aws_backup_selection.this.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role that AWS Backup uses to authenticate when restoring and backing up the target resource."
  value       = data.aws_backup_selection.this.iam_role_arn
}

output "resources" {
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan."
  value       = data.aws_backup_selection.this.resources
}