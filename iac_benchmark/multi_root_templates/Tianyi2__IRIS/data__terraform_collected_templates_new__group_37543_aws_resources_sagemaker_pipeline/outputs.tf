output "id" {
  description = "The name of the Pipeline."
  value       = aws_sagemaker_pipeline.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Pipeline."
  value       = aws_sagemaker_pipeline.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_pipeline.this.tags_all
}