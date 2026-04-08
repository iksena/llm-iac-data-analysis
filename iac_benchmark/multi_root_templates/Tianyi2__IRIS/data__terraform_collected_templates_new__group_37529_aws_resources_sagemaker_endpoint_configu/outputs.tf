output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this endpoint configuration."
  value       = aws_sagemaker_endpoint_configuration.this.arn
}

output "name" {
  description = "The name of the endpoint configuration."
  value       = aws_sagemaker_endpoint_configuration.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_endpoint_configuration.this.tags_all
}