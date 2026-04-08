output "arn" {
  description = "ARN of the table."
  value       = aws_s3tables_table.this.arn
}

output "created_at" {
  description = "Date and time when the namespace was created."
  value       = aws_s3tables_table.this.created_at
}

output "created_by" {
  description = "Account ID of the account that created the namespace."
  value       = aws_s3tables_table.this.created_by
}

output "metadata_location" {
  description = "Location of table metadata."
  value       = aws_s3tables_table.this.metadata_location
}

output "modified_at" {
  description = "Date and time when the namespace was last modified."
  value       = aws_s3tables_table.this.modified_at
}

output "modified_by" {
  description = "Account ID of the account that last modified the namespace."
  value       = aws_s3tables_table.this.modified_by
}

output "owner_account_id" {
  description = "Account ID of the account that owns the namespace."
  value       = aws_s3tables_table.this.owner_account_id
}

output "type" {
  description = "Type of the table. One of 'customer' or 'aws'."
  value       = aws_s3tables_table.this.type
}

output "version_token" {
  description = "Identifier for the current version of table data."
  value       = aws_s3tables_table.this.version_token
}

output "warehouse_location" {
  description = "S3 URI pointing to the S3 Bucket that contains the table data."
  value       = aws_s3tables_table.this.warehouse_location
}