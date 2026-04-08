output "cdc_start_position" {
  description = "Indicates when you want a change data capture (CDC) operation to start. The value can be in date, checkpoint, or LSN/SCN format depending on the source engine."
  value       = data.aws_dms_replication_task.this.cdc_start_position
}

output "cdc_start_time" {
  description = "The Unix timestamp integer for the start of the Change Data Capture (CDC) operation."
  value       = data.aws_dms_replication_task.this.cdc_start_time
}

output "migration_type" {
  description = "The migration type. Can be one of full-load | cdc | full-load-and-cdc."
  value       = data.aws_dms_replication_task.this.migration_type
}

output "replication_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the replication instance."
  value       = data.aws_dms_replication_task.this.replication_instance_arn
}

output "replication_task_settings" {
  description = "An escaped JSON string that contains the task settings."
  value       = data.aws_dms_replication_task.this.replication_task_settings
}

output "source_endpoint_arn" {
  description = "The Amazon Resource Name (ARN) string that uniquely identifies the source endpoint."
  value       = data.aws_dms_replication_task.this.source_endpoint_arn
}

output "start_replication_task" {
  description = "Whether to run or stop the replication task."
  value       = data.aws_dms_replication_task.this.start_replication_task
}

output "status" {
  description = "Replication Task status."
  value       = data.aws_dms_replication_task.this.status
}

output "table_mappings" {
  description = "An escaped JSON string that contains the table mappings."
  value       = data.aws_dms_replication_task.this.table_mappings
}

output "target_endpoint_arn" {
  description = "The Amazon Resource Name (ARN) string that uniquely identifies the target endpoint."
  value       = data.aws_dms_replication_task.this.target_endpoint_arn
}

output "replication_task_arn" {
  description = "The Amazon Resource Name (ARN) for the replication task."
  value       = data.aws_dms_replication_task.this.replication_task_arn
}