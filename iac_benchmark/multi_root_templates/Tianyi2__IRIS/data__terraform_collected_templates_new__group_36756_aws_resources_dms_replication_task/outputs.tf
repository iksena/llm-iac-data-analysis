output "region" {
  description = "Region where this resource is managed."
  value       = aws_dms_replication_task.this.region
}

output "cdc_start_position" {
  description = "CDC start position."
  value       = aws_dms_replication_task.this.cdc_start_position
}

output "cdc_start_time" {
  description = "RFC3339 formatted date string or UNIX timestamp for the start of the Change Data Capture (CDC) operation."
  value       = aws_dms_replication_task.this.cdc_start_time
}

output "migration_type" {
  description = "Migration type."
  value       = aws_dms_replication_task.this.migration_type
}

output "replication_instance_arn" {
  description = "ARN of the replication instance."
  value       = aws_dms_replication_task.this.replication_instance_arn
}

output "replication_task_id" {
  description = "Replication task identifier."
  value       = aws_dms_replication_task.this.replication_task_id
}

output "replication_task_settings" {
  description = "Escaped JSON string that contains the task settings."
  value       = aws_dms_replication_task.this.replication_task_settings
}

output "resource_identifier" {
  description = "A friendly name for the resource identifier."
  value       = aws_dms_replication_task.this.resource_identifier
}

output "source_endpoint_arn" {
  description = "ARN that uniquely identifies the source endpoint."
  value       = aws_dms_replication_task.this.source_endpoint_arn
}

output "start_replication_task" {
  description = "Whether to run or stop the replication task."
  value       = aws_dms_replication_task.this.start_replication_task
}

output "table_mappings" {
  description = "Escaped JSON string that contains the table mappings."
  value       = aws_dms_replication_task.this.table_mappings
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_dms_replication_task.this.tags
}

output "target_endpoint_arn" {
  description = "ARN that uniquely identifies the target endpoint."
  value       = aws_dms_replication_task.this.target_endpoint_arn
}

output "replication_task_arn" {
  description = "ARN for the replication task."
  value       = aws_dms_replication_task.this.replication_task_arn
}

output "status" {
  description = "Replication Task status."
  value       = aws_dms_replication_task.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dms_replication_task.this.tags_all
}