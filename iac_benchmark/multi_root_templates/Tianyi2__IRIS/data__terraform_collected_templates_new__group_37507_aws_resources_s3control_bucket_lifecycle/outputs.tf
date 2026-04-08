output "id" {
  description = "Amazon Resource Name (ARN) of the bucket."
  value       = aws_s3control_bucket_lifecycle_configuration.this.id
}