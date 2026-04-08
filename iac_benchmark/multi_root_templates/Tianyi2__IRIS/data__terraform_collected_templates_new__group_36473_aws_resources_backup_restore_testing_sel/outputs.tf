output "name" {
  description = "The name of the backup restore testing selection."
  value       = aws_backup_restore_testing_selection.this.name
}

output "restore_testing_plan_name" {
  description = "The name of the restore testing plan."
  value       = aws_backup_restore_testing_selection.this.restore_testing_plan_name
}