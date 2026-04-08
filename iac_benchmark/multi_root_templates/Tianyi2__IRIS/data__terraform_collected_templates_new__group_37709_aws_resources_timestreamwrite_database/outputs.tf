output "id" {
  description = "The name of the Timestream database."
  value       = aws_timestreamwrite_database.this.id
}

output "arn" {
  description = "The ARN that uniquely identifies this database."
  value       = aws_timestreamwrite_database.this.arn
}

output "kms_key_id" {
  description = "The ARN of the KMS key used to encrypt the data stored in the database."
  value       = aws_timestreamwrite_database.this.kms_key_id
}

output "table_count" {
  description = "The total number of tables found within the Timestream database."
  value       = aws_timestreamwrite_database.this.table_count
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_timestreamwrite_database.this.tags_all
}