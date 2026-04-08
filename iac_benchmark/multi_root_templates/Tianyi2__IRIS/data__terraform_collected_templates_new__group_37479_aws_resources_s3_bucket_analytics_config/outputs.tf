output "id" {
  description = "The ID of the S3 bucket analytics configuration."
  value       = aws_s3_bucket_analytics_configuration.this.id
}

output "bucket" {
  description = "The name of the bucket this analytics configuration is associated with."
  value       = aws_s3_bucket_analytics_configuration.this.bucket
}

output "name" {
  description = "The unique identifier of the analytics configuration for the bucket."
  value       = aws_s3_bucket_analytics_configuration.this.name
}