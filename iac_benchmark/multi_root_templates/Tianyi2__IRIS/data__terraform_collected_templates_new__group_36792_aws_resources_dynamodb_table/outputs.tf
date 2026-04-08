output "arn" {
  description = "ARN of the table"
  value       = aws_dynamodb_table.this.arn
}

output "id" {
  description = "Name of the table"
  value       = aws_dynamodb_table.this.id
}

output "stream_arn" {
  description = "ARN of the Table Stream. Only available when stream_enabled = true"
  value       = aws_dynamodb_table.this.stream_arn
}

output "stream_label" {
  description = "Timestamp, in ISO 8601 format, for this stream. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms. Only available when stream_enabled = true"
  value       = aws_dynamodb_table.this.stream_label
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dynamodb_table.this.tags_all
}

output "replica_arns" {
  description = "ARN of the replicas"
  value       = [for replica in aws_dynamodb_table.this.replica : replica.arn]
}

output "replica_stream_arns" {
  description = "ARN of the replica Table Streams. Only available when stream_enabled = true"
  value       = [for replica in aws_dynamodb_table.this.replica : replica.stream_arn]
}

output "replica_stream_labels" {
  description = "Timestamp, in ISO 8601 format, for the replica streams. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms. Only available when stream_enabled = true"
  value       = [for replica in aws_dynamodb_table.this.replica : replica.stream_label]
}