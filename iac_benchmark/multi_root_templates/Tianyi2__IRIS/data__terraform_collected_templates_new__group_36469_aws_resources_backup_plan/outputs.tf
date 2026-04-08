output "id" {
  description = "The id of the backup plan."
  value       = aws_backup_plan.this.id
}

output "arn" {
  description = "The ARN of the backup plan."
  value       = aws_backup_plan.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_backup_plan.this.tags_all
}

output "version" {
  description = "Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan."
  value       = aws_backup_plan.this.version
}