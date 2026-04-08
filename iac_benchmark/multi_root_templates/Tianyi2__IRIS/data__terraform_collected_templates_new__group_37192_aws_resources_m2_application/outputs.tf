output "application_id" {
  description = "ID of the Application"
  value       = aws_m2_application.this.application_id
}

output "arn" {
  description = "ARN of the Application"
  value       = aws_m2_application.this.arn
}

output "current_version" {
  description = "Current version of the application deployed"
  value       = aws_m2_application.this.current_version
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_m2_application.this.tags_all
}