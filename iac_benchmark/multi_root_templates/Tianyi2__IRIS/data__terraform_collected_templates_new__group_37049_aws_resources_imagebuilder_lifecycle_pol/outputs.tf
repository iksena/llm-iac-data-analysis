output "id" {
  description = "Amazon Resource Name (ARN) of the lifecycle policy."
  value       = aws_imagebuilder_lifecycle_policy.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the lifecycle policy."
  value       = aws_imagebuilder_lifecycle_policy.this.arn
}

output "status" {
  description = "The status of the lifecycle policy."
  value       = aws_imagebuilder_lifecycle_policy.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_imagebuilder_lifecycle_policy.this.tags_all
}