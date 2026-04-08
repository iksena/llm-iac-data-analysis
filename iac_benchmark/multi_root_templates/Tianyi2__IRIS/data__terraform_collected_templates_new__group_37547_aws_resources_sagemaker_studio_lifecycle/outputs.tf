output "id" {
  description = "The name of the Studio Lifecycle Config"
  value       = aws_sagemaker_studio_lifecycle_config.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Studio Lifecycle Config"
  value       = aws_sagemaker_studio_lifecycle_config.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sagemaker_studio_lifecycle_config.this.tags_all
}