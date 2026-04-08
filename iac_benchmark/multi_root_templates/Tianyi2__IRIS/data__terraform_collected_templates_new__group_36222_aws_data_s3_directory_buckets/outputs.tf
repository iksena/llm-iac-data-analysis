output "arns" {
  description = "Bucket ARNs"
  value       = data.aws_s3_directory_buckets.this.arns
}

output "buckets" {
  description = "Buckets names"
  value       = data.aws_s3_directory_buckets.this.buckets
}