output "arn" {
  description = "ARN of the Application"
  value       = aws_applicationinsights_application.this.arn
}

output "id" {
  description = "Name of the resource group"
  value       = aws_applicationinsights_application.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_applicationinsights_application.this.tags_all
}