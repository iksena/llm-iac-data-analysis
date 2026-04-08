output "account_id" {
  description = "The AWS account ID that owns the specified access point"
  value       = aws_s3control_directory_bucket_access_point_scope.this.account_id
}

output "name" {
  description = "The name of the access point that you want to apply the scope to"
  value       = aws_s3control_directory_bucket_access_point_scope.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_s3control_directory_bucket_access_point_scope.this.region
}

output "scope" {
  description = "Scope configuration for the access point"
  value       = aws_s3control_directory_bucket_access_point_scope.this.scope
}