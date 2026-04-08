output "region" {
  description = "Region where this resource will be managed."
  value       = aws_cognito_resource_server.this.region
}

output "identifier" {
  description = "An identifier for the resource server."
  value       = aws_cognito_resource_server.this.identifier
}

output "name" {
  description = "A name for the resource server."
  value       = aws_cognito_resource_server.this.name
}

output "user_pool_id" {
  description = "User pool the client belongs to."
  value       = aws_cognito_resource_server.this.user_pool_id
}

output "scope" {
  description = "A list of Authorization Scope."
  value       = aws_cognito_resource_server.this.scope
}

output "scope_identifiers" {
  description = "A list of all scopes configured for this resource server in the format identifier/scope_name."
  value       = aws_cognito_resource_server.this.scope_identifiers
}