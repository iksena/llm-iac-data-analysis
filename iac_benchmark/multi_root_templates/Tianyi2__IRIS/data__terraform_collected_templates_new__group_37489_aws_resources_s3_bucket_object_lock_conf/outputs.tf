output "id" {
  description = "The bucket or bucket and expected_bucket_owner separated by a comma (,) if the latter is provided."
  value       = aws_s3_bucket_object_lock_configuration.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_s3_bucket_object_lock_configuration.this.region
}

output "bucket" {
  description = "Name of the bucket."
  value       = aws_s3_bucket_object_lock_configuration.this.bucket
}

output "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  value       = aws_s3_bucket_object_lock_configuration.this.expected_bucket_owner
}

output "object_lock_enabled" {
  description = "Indicates whether this bucket has an Object Lock configuration enabled."
  value       = aws_s3_bucket_object_lock_configuration.this.object_lock_enabled
}

output "rule" {
  description = "Configuration block for specifying the Object Lock rule for the specified object."
  value       = aws_s3_bucket_object_lock_configuration.this.rule
}

output "token" {
  description = "Token used to enable Object Lock (deprecated)."
  value       = aws_s3_bucket_object_lock_configuration.this.token
}