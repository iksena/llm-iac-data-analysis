output "arn" {
  description = "The ARN of the table."
  value       = aws_keyspaces_table.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_keyspaces_table.this.tags_all
}

output "keyspace_name" {
  description = "The name of the keyspace that the table is going to be created in."
  value       = aws_keyspaces_table.this.keyspace_name
}

output "table_name" {
  description = "The name of the table."
  value       = aws_keyspaces_table.this.table_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_keyspaces_table.this.region
}

output "default_time_to_live" {
  description = "The default Time to Live setting in seconds for the table."
  value       = aws_keyspaces_table.this.default_time_to_live
}

output "capacity_specification" {
  description = "The read/write throughput capacity mode for the table."
  value       = aws_keyspaces_table.this.capacity_specification
}

output "client_side_timestamps" {
  description = "Client-side timestamps settings for the table."
  value       = aws_keyspaces_table.this.client_side_timestamps
}

output "comment" {
  description = "The description of the table."
  value       = aws_keyspaces_table.this.comment
}

output "encryption_specification" {
  description = "The encryption key for encryption at rest management for the table."
  value       = aws_keyspaces_table.this.encryption_specification
}

output "point_in_time_recovery" {
  description = "Point-in-time recovery settings for the table."
  value       = aws_keyspaces_table.this.point_in_time_recovery
}

output "schema_definition" {
  description = "The schema of the table."
  value       = aws_keyspaces_table.this.schema_definition
}

output "ttl" {
  description = "Time to Live custom settings for the table."
  value       = aws_keyspaces_table.this.ttl
}