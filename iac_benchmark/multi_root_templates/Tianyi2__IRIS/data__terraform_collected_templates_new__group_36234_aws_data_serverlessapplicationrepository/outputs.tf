output "application_id" {
  description = "ARN of the application"
  value       = data.aws_serverlessapplicationrepository_application.this.application_id
}

output "name" {
  description = "Name of the application"
  value       = data.aws_serverlessapplicationrepository_application.this.name
}

output "required_capabilities" {
  description = "A list of capabilities describing the permissions needed to deploy the application"
  value       = data.aws_serverlessapplicationrepository_application.this.required_capabilities
}

output "source_code_url" {
  description = "URL pointing to the source code of the application version"
  value       = data.aws_serverlessapplicationrepository_application.this.source_code_url
}

output "template_url" {
  description = "URL pointing to the Cloud Formation template for the application version"
  value       = data.aws_serverlessapplicationrepository_application.this.template_url
}

output "semantic_version" {
  description = "Requested version of the application"
  value       = data.aws_serverlessapplicationrepository_application.this.semantic_version
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_serverlessapplicationrepository_application.this.region
}