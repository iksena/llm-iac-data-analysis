output "id" {
  description = "The bucket or bucket and expected_bucket_owner separated by a comma if the latter is provided"
  value       = aws_s3_bucket_accelerate_configuration.this.id
}

output "bucket" {
  description = "Name of the bucket"
  value       = aws_s3_bucket_accelerate_configuration.this.bucket
}

output "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner"
  value       = aws_s3_bucket_accelerate_configuration.this.expected_bucket_owner
}

output "status" {
  description = "Transfer acceleration state of the bucket"
  value       = aws_s3_bucket_accelerate_configuration.this.status
}