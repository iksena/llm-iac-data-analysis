output "id" {
  description = "The ID of the S3 bucket metric configuration."
  value       = aws_s3_bucket_metric.this.id
}

output "region" {
  description = "The region of the S3 bucket metric configuration."
  value       = aws_s3_bucket_metric.this.region
}

output "bucket" {
  description = "The name of the bucket."
  value       = aws_s3_bucket_metric.this.bucket
}

output "name" {
  description = "The name of the metrics configuration."
  value       = aws_s3_bucket_metric.this.name
}