output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this endpoint."
  value       = aws_sagemaker_endpoint.this.arn
}

output "name" {
  description = "The name of the endpoint."
  value       = aws_sagemaker_endpoint.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_endpoint.this.tags_all
}