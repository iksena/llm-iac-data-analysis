output "id" {
  description = "Database name"
  value       = aws_athena_database.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_athena_database.this.region
}

output "bucket" {
  description = "Name of S3 bucket to save the results of the query execution"
  value       = aws_athena_database.this.bucket
}

output "name" {
  description = "Name of the database"
  value       = aws_athena_database.this.name
}

output "comment" {
  description = "Description of the database"
  value       = aws_athena_database.this.comment
}

output "expected_bucket_owner" {
  description = "AWS account ID that you expect to be the owner of the Amazon S3 bucket"
  value       = aws_athena_database.this.expected_bucket_owner
}

output "force_destroy" {
  description = "Boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error"
  value       = aws_athena_database.this.force_destroy
}

output "properties" {
  description = "Key-value map of custom metadata properties for the database definition"
  value       = aws_athena_database.this.properties
}

output "workgroup" {
  description = "Name of the workgroup"
  value       = aws_athena_database.this.workgroup
}

output "acl_configuration" {
  description = "ACL configuration for S3 canned ACL"
  value       = var.acl_configuration
}

output "encryption_configuration" {
  description = "Encryption configuration for AWS Athena"
  value       = var.encryption_configuration
}