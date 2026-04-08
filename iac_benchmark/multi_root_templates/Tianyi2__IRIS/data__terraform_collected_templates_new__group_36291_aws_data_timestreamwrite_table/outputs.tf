output "arn" {
  description = "ARN that uniquely identifies the table."
  value       = data.aws_timestreamwrite_table.this.arn
}

output "creation_time" {
  description = "Time that table was created."
  value       = data.aws_timestreamwrite_table.this.creation_time
}

output "database_name" {
  description = "Name of database."
  value       = data.aws_timestreamwrite_table.this.database_name
}

output "last_updated_time" {
  description = "Last time table was updated."
  value       = data.aws_timestreamwrite_table.this.last_updated_time
}

output "magnetic_store_write_properties" {
  description = "Object containing the following attributes to desribe magnetic store writes."
  value       = data.aws_timestreamwrite_table.this.magnetic_store_write_properties
}

output "retention_properties" {
  description = "Object containing the following attributes to describe the retention duration for the memory and magnetic stores."
  value       = data.aws_timestreamwrite_table.this.retention_properties
}

output "schema" {
  description = "Object containing the following attributes to describe the schema of the table."
  value       = data.aws_timestreamwrite_table.this.schema
}

output "name" {
  description = "Name of the table."
  value       = data.aws_timestreamwrite_table.this.name
}

output "table_status" {
  description = "Current state of table."
  value       = data.aws_timestreamwrite_table.this.table_status
}