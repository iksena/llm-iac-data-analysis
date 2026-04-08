output "id" {
  description = "Name of the bucket (deprecated, use bucket instead)"
  value       = aws_s3_directory_bucket.this.id
}

output "bucket" {
  description = "Name of the bucket"
  value       = aws_s3_directory_bucket.this.bucket
}

output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_directory_bucket.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_s3_directory_bucket.this.tags_all
}