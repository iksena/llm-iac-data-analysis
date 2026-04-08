output "arn" {
  description = "Amazon Resource Name (ARN) of the DynamoDB table"
  value       = data.aws_dynamodb_table.this.arn
}

output "attributes" {
  description = "List of nested attribute definitions"
  value       = data.aws_dynamodb_table.this.attribute
}

output "billing_mode" {
  description = "Billing mode of the table"
  value       = data.aws_dynamodb_table.this.billing_mode
}

output "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled"
  value       = data.aws_dynamodb_table.this.deletion_protection_enabled
}

output "global_secondary_index" {
  description = "List of global secondary indexes"
  value       = data.aws_dynamodb_table.this.global_secondary_index
}

output "hash_key" {
  description = "Hash key of the table"
  value       = data.aws_dynamodb_table.this.hash_key
}

output "id" {
  description = "Name of the table"
  value       = data.aws_dynamodb_table.this.id
}

output "local_secondary_index" {
  description = "List of local secondary indexes"
  value       = data.aws_dynamodb_table.this.local_secondary_index
}

output "name" {
  description = "Name of the DynamoDB table"
  value       = data.aws_dynamodb_table.this.name
}

output "point_in_time_recovery" {
  description = "Point-in-time recovery options"
  value       = data.aws_dynamodb_table.this.point_in_time_recovery
}

output "range_key" {
  description = "Range key of the table"
  value       = data.aws_dynamodb_table.this.range_key
}

output "read_capacity" {
  description = "Read capacity units for the table"
  value       = data.aws_dynamodb_table.this.read_capacity
}

output "replica" {
  description = "List of replica configuration blocks"
  value       = data.aws_dynamodb_table.this.replica
}

output "server_side_encryption" {
  description = "Server-side encryption configuration"
  value       = data.aws_dynamodb_table.this.server_side_encryption
}

output "stream_arn" {
  description = "ARN of the Table Stream"
  value       = data.aws_dynamodb_table.this.stream_arn
}

output "stream_enabled" {
  description = "Whether streams are enabled"
  value       = data.aws_dynamodb_table.this.stream_enabled
}

output "stream_label" {
  description = "Timestamp when the stream was enabled"
  value       = data.aws_dynamodb_table.this.stream_label
}

output "stream_view_type" {
  description = "Stream view type"
  value       = data.aws_dynamodb_table.this.stream_view_type
}

output "table_class" {
  description = "Storage class of the table"
  value       = data.aws_dynamodb_table.this.table_class
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = data.aws_dynamodb_table.this.tags
}

output "ttl" {
  description = "Time-to-live configuration"
  value       = data.aws_dynamodb_table.this.ttl
}

output "write_capacity" {
  description = "Write capacity units for the table"
  value       = data.aws_dynamodb_table.this.write_capacity
}