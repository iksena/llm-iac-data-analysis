output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this lifecycle configuration."
  value       = aws_sagemaker_notebook_instance_lifecycle_configuration.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_notebook_instance_lifecycle_configuration.this.tags_all
}