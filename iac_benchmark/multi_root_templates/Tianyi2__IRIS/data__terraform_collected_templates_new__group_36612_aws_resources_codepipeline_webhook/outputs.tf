output "arn" {
  description = "The CodePipeline webhook's ARN"
  value       = aws_codepipeline_webhook.this.arn
}

output "id" {
  description = "The CodePipeline webhook's ARN"
  value       = aws_codepipeline_webhook.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_codepipeline_webhook.this.tags_all
}

output "url" {
  description = "The CodePipeline webhook's URL. POST events to this endpoint to trigger the target"
  value       = aws_codepipeline_webhook.this.url
}