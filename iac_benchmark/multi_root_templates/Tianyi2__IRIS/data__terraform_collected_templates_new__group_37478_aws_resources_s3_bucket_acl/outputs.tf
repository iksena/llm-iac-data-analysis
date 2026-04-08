output "id" {
  description = "The bucket, expected_bucket_owner (if configured), and acl (if configured) separated by commas."
  value       = aws_s3_bucket_acl.this.id
}