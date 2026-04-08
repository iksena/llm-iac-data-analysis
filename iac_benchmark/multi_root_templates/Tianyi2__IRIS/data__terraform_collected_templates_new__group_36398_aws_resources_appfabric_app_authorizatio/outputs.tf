output "arn" {
  description = "ARN of the App Authorization."
  value       = aws_appfabric_app_authorization.this.arn
}

output "auth_url" {
  description = "The application URL for the OAuth flow."
  value       = aws_appfabric_app_authorization.this.auth_url
}

output "persona" {
  description = "The user persona of the app authorization."
  value       = aws_appfabric_app_authorization.this.persona
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_appfabric_app_authorization.this.region
}

output "app" {
  description = "The name of the application."
  value       = aws_appfabric_app_authorization.this.app
}

output "app_bundle_arn" {
  description = "The Amazon Resource Name (ARN) of the app bundle."
  value       = aws_appfabric_app_authorization.this.app_bundle_arn
}

output "auth_type" {
  description = "The authorization type for the app authorization."
  value       = aws_appfabric_app_authorization.this.auth_type
}

output "credential" {
  description = "Contains credentials for the application."
  value       = aws_appfabric_app_authorization.this.credential
  sensitive   = true
}

output "tenant" {
  description = "Contains information about an application tenant."
  value       = aws_appfabric_app_authorization.this.tenant
}