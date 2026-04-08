output "application_account" {
  description = "AWS account ID."
  value       = data.aws_ssoadmin_application.this.application_account
}

output "application_provider_arn" {
  description = "ARN of the application provider."
  value       = data.aws_ssoadmin_application.this.application_provider_arn
}

output "description" {
  description = "Description of the application."
  value       = data.aws_ssoadmin_application.this.description
}

output "id" {
  description = "ARN of the application."
  value       = data.aws_ssoadmin_application.this.id
}

output "instance_arn" {
  description = "ARN of the instance of IAM Identity Center."
  value       = data.aws_ssoadmin_application.this.instance_arn
}

output "name" {
  description = "Name of the application."
  value       = data.aws_ssoadmin_application.this.name
}

output "portal_options" {
  description = "Options for the portal associated with an application."
  value       = data.aws_ssoadmin_application.this.portal_options
}

output "status" {
  description = "Status of the application."
  value       = data.aws_ssoadmin_application.this.status
}