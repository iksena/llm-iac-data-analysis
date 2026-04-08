output "id" {
  description = "S3 Bucket name."
  value       = aws_s3_bucket_ownership_controls.this.id
}