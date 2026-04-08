output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Flow Definition"
  value       = aws_sagemaker_flow_definition.this.arn
}

output "id" {
  description = "The name of the Flow Definition"
  value       = aws_sagemaker_flow_definition.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sagemaker_flow_definition.this.tags_all
}