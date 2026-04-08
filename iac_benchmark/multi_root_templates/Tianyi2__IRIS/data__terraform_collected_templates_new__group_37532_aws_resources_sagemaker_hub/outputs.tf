output "id" {
  description = "The name of the Hub."
  value       = aws_sagemaker_hub.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Hub."
  value       = aws_sagemaker_hub.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_hub.this.tags_all
}