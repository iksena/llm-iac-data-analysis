output "id" {
  description = "The name of the Image."
  value       = aws_sagemaker_image.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Image."
  value       = aws_sagemaker_image.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_image.this.tags_all
}