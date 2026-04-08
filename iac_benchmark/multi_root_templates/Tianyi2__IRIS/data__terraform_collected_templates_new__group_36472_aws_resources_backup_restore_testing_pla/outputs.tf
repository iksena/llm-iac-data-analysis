output "arn" {
  description = "ARN of the Restore Testing Plan"
  value       = aws_backup_restore_testing_plan.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_backup_restore_testing_plan.this.tags_all
}