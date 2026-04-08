output "id" {
  description = "The name of the Code Repository"
  value       = aws_sagemaker_code_repository.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Code Repository"
  value       = aws_sagemaker_code_repository.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sagemaker_code_repository.this.tags_all
}