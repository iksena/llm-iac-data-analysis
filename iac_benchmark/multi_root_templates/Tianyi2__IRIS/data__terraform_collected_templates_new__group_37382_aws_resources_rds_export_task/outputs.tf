output "failure_cause" {
  description = "Reason the export failed, if it failed"
  value       = aws_rds_export_task.this.failure_cause
}

output "id" {
  description = "Unique identifier for the snapshot export task (same value as export_task_identifier)"
  value       = aws_rds_export_task.this.id
}

output "percent_progress" {
  description = "Progress of the snapshot export task as a percentage"
  value       = aws_rds_export_task.this.percent_progress
}

output "snapshot_time" {
  description = "Time that the snapshot was created"
  value       = aws_rds_export_task.this.snapshot_time
}

output "source_type" {
  description = "Type of source for the export"
  value       = aws_rds_export_task.this.source_type
}

output "status" {
  description = "Status of the export task"
  value       = aws_rds_export_task.this.status
}

output "task_end_time" {
  description = "Time that the snapshot export task completed"
  value       = aws_rds_export_task.this.task_end_time
}

output "task_start_time" {
  description = "Time that the snapshot export task started"
  value       = aws_rds_export_task.this.task_start_time
}

output "warning_message" {
  description = "Warning about the snapshot export task, if any"
  value       = aws_rds_export_task.this.warning_message
}