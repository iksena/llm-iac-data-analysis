output "app" {
  description = "The name of the application."
  value       = aws_appfabric_app_authorization_connection.this.app
}

output "tenant" {
  description = "Contains information about an application tenant, such as the application display name and identifier."
  value       = aws_appfabric_app_authorization_connection.this.tenant
}

output "id" {
  description = "The ID of the AppFabric app authorization connection."
  value       = aws_appfabric_app_authorization_connection.this.id
}

output "arn" {
  description = "The ARN of the AppFabric app authorization connection."
  value       = aws_appfabric_app_authorization_connection.this.id
}