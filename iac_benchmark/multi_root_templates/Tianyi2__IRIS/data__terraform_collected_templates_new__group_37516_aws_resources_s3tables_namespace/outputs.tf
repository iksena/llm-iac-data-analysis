output "region" {
  description = "Region where this resource will be managed."
  value       = aws_s3tables_namespace.this.region
}

output "namespace" {
  description = "Name of the namespace."
  value       = aws_s3tables_namespace.this.namespace
}

output "table_bucket_arn" {
  description = "ARN referencing the Table Bucket that contains this Namespace."
  value       = aws_s3tables_namespace.this.table_bucket_arn
}

output "created_at" {
  description = "Date and time when the namespace was created."
  value       = aws_s3tables_namespace.this.created_at
}

output "created_by" {
  description = "Account ID of the account that created the namespace."
  value       = aws_s3tables_namespace.this.created_by
}

output "owner_account_id" {
  description = "Account ID of the account that owns the namespace."
  value       = aws_s3tables_namespace.this.owner_account_id
}