output "id" {
  description = "The ARN of the Domain."
  value       = aws_codeartifact_domain.this.id
}

output "arn" {
  description = "The ARN of the Domain."
  value       = aws_codeartifact_domain.this.arn
}

output "owner" {
  description = "The AWS account ID that owns the domain."
  value       = aws_codeartifact_domain.this.owner
}

output "repository_count" {
  description = "The number of repositories in the domain."
  value       = aws_codeartifact_domain.this.repository_count
}

output "s3_bucket_arn" {
  description = "The ARN of the Amazon S3 bucket that is used to store package assets in the domain."
  value       = aws_codeartifact_domain.this.s3_bucket_arn
}

output "created_time" {
  description = "A timestamp that represents the date and time the domain was created in RFC3339 format."
  value       = aws_codeartifact_domain.this.created_time
}

output "asset_size_bytes" {
  description = "The total size of all assets in the domain."
  value       = aws_codeartifact_domain.this.asset_size_bytes
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codeartifact_domain.this.tags_all
}