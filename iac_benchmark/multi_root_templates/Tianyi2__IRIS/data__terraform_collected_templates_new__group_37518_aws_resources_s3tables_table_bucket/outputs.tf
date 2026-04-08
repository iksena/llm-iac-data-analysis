output "arn" {
  description = "ARN of the table bucket."
  value       = aws_s3tables_table_bucket.this.arn
}

output "created_at" {
  description = "Date and time when the bucket was created."
  value       = aws_s3tables_table_bucket.this.created_at
}

output "owner_account_id" {
  description = "Account ID of the account that owns the table bucket."
  value       = aws_s3tables_table_bucket.this.owner_account_id
}

output "name" {
  description = "Name of the table bucket."
  value       = aws_s3tables_table_bucket.this.name
}

output "encryption_configuration" {
  description = "The table bucket encryption configuration."
  value       = aws_s3tables_table_bucket.this.encryption_configuration
}

output "force_destroy" {
  description = "Whether all tables and namespaces within the table bucket should be deleted when destroyed."
  value       = aws_s3tables_table_bucket.this.force_destroy
}

output "maintenance_configuration" {
  description = "The table bucket maintenance configuration."
  value       = aws_s3tables_table_bucket.this.maintenance_configuration
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_s3tables_table_bucket.this.region
}