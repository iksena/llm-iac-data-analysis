output "id" {
  description = "S3 source bucket name."
  value       = aws_s3_bucket_replication_configuration.this.id
}