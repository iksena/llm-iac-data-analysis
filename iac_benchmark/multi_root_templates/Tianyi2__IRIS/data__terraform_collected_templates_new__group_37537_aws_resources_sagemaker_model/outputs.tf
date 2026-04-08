output "name" {
  description = "The name of the model"
  value       = aws_sagemaker_model.this.name
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this model"
  value       = aws_sagemaker_model.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sagemaker_model.this.tags_all
}