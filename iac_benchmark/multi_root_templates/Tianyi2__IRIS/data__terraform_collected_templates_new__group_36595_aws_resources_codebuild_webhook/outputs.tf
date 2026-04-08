output "id" {
  description = "The name of the build project."
  value       = aws_codebuild_webhook.this.id
}

output "payload_url" {
  description = "The CodeBuild endpoint where webhook events are sent."
  value       = aws_codebuild_webhook.this.payload_url
}

output "secret" {
  description = "The secret token of the associated repository. Not returned by the CodeBuild API for all source types."
  value       = aws_codebuild_webhook.this.secret
  sensitive   = true
}

output "url" {
  description = "The URL to the webhook."
  value       = aws_codebuild_webhook.this.url
}