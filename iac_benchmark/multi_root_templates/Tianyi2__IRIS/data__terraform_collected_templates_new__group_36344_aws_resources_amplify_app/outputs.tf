output "arn" {
  description = "ARN of the Amplify app"
  value       = aws_amplify_app.this.arn
}

output "default_domain" {
  description = "Default domain for the Amplify app"
  value       = aws_amplify_app.this.default_domain
}

output "id" {
  description = "Unique ID of the Amplify app"
  value       = aws_amplify_app.this.id
}

output "production_branch" {
  description = "Describes the information about a production branch for an Amplify app"
  value       = aws_amplify_app.this.production_branch
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_amplify_app.this.tags_all
}