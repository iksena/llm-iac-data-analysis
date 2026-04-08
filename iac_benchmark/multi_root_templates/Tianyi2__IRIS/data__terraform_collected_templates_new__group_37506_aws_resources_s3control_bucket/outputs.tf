output "arn" {
  description = "Amazon Resource Name (ARN) of the bucket."
  value       = aws_s3control_bucket.this.arn
}

output "creation_date" {
  description = "UTC creation date in RFC3339 format."
  value       = aws_s3control_bucket.this.creation_date
}

output "id" {
  description = "Amazon Resource Name (ARN) of the bucket."
  value       = aws_s3control_bucket.this.id
}

output "public_access_block_enabled" {
  description = "Boolean whether Public Access Block is enabled."
  value       = aws_s3control_bucket.this.public_access_block_enabled
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3control_bucket.this.tags_all
}