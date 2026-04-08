output "arn" {
  description = "ARN for the webhook"
  value       = aws_amplify_webhook.this.arn
}

output "url" {
  description = "URL of the webhook"
  value       = aws_amplify_webhook.this.url
}

output "app_id" {
  description = "Unique ID for an Amplify app"
  value       = aws_amplify_webhook.this.app_id
}

output "branch_name" {
  description = "Name for a branch that is part of the Amplify app"
  value       = aws_amplify_webhook.this.branch_name
}

output "description" {
  description = "Description for a webhook"
  value       = aws_amplify_webhook.this.description
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_amplify_webhook.this.region
}