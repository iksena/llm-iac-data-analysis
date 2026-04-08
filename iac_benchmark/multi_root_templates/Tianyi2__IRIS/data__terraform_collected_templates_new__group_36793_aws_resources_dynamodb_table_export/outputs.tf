output "arn" {
  description = "ARN of the Table Export"
  value       = aws_dynamodb_table_export.this.arn
}

output "billed_size_in_bytes" {
  description = "Billable size of the table export"
  value       = aws_dynamodb_table_export.this.billed_size_in_bytes
}

output "end_time" {
  description = "Time at which the export task completed"
  value       = aws_dynamodb_table_export.this.end_time
}

output "export_status" {
  description = "Status of the export - export can be in one of the following states IN_PROGRESS, COMPLETED, or FAILED"
  value       = aws_dynamodb_table_export.this.export_status
}

output "item_count" {
  description = "Number of items exported"
  value       = aws_dynamodb_table_export.this.item_count
}

output "manifest_files_s3_key" {
  description = "Name of the manifest file for the export task"
  value       = aws_dynamodb_table_export.this.manifest_files_s3_key
}

output "start_time" {
  description = "Time at which the export task began"
  value       = aws_dynamodb_table_export.this.start_time
}