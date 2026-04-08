output "application_account" {
  description = "AWS account ID"
  value       = aws_ssoadmin_application.this.application_account
}

output "application_arn" {
  description = "ARN of the application (deprecated - use arn instead)"
  value       = aws_ssoadmin_application.this.application_arn
}

output "arn" {
  description = "ARN of the application"
  value       = aws_ssoadmin_application.this.arn
}

output "id" {
  description = "ARN of the application (deprecated - use arn instead)"
  value       = aws_ssoadmin_application.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ssoadmin_application.this.tags_all
}