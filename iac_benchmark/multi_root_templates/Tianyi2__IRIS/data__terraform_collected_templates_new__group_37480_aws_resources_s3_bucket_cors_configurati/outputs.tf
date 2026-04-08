output "id" {
  description = "The bucket or bucket and expected_bucket_owner separated by a comma (,) if the latter is provided."
  value       = aws_s3_bucket_cors_configuration.this.id
}

output "bucket" {
  description = "Name of the bucket."
  value       = aws_s3_bucket_cors_configuration.this.bucket
}

output "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  value       = aws_s3_bucket_cors_configuration.this.expected_bucket_owner
}

output "cors_rule" {
  description = "Set of origins and methods (cross-origin access that you want to allow)."
  value       = aws_s3_bucket_cors_configuration.this.cors_rule
}