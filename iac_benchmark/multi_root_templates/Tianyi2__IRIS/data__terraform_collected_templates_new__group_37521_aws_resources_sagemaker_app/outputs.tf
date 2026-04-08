output "id" {
  description = "The Amazon Resource Name (ARN) of the app"
  value       = aws_sagemaker_app.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the app"
  value       = aws_sagemaker_app.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sagemaker_app.this.tags_all
}