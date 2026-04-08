output "arn" {
  description = "The ARN that uniquely identifies this database."
  value       = data.aws_timestreamwrite_database.this.arn
}

output "created_time" {
  description = "Creation time of database."
  value       = data.aws_timestreamwrite_database.this.created_time
}

output "database_name" {
  description = "The name of the Timestream database."
  value       = data.aws_timestreamwrite_database.this.name
}

output "kms_key_id" {
  description = "The ARN of the KMS key used to encrypt the data stored in the database."
  value       = data.aws_timestreamwrite_database.this.kms_key_id
}

output "last_updated_time" {
  description = "Last time database was updated."
  value       = data.aws_timestreamwrite_database.this.last_updated_time
}

output "table_count" {
  description = "Total number of tables in the Timestream database."
  value       = data.aws_timestreamwrite_database.this.table_count
}