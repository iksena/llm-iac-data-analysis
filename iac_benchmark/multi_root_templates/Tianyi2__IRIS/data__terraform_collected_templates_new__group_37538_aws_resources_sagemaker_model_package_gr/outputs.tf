output "id" {
  description = "The name of the Model Package Group."
  value       = aws_sagemaker_model_package_group.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Model Package Group."
  value       = aws_sagemaker_model_package_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_model_package_group.this.tags_all
}