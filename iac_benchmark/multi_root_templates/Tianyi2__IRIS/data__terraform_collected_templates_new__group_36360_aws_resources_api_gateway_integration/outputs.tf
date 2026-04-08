output "id" {
  description = "The ID of the API Gateway integration"
  value       = aws_api_gateway_integration.this.id
}

output "rest_api_id" {
  description = "The ID of the associated REST API"
  value       = aws_api_gateway_integration.this.rest_api_id
}

output "resource_id" {
  description = "The API resource ID"
  value       = aws_api_gateway_integration.this.resource_id
}

output "http_method" {
  description = "The HTTP method"
  value       = aws_api_gateway_integration.this.http_method
}

output "integration_http_method" {
  description = "The integration HTTP method"
  value       = aws_api_gateway_integration.this.integration_http_method
}

output "type" {
  description = "The integration type"
  value       = aws_api_gateway_integration.this.type
}

output "connection_type" {
  description = "The integration connection type"
  value       = aws_api_gateway_integration.this.connection_type
}

output "connection_id" {
  description = "The ID of the VpcLink used for the integration"
  value       = aws_api_gateway_integration.this.connection_id
}

output "uri" {
  description = "The input URI"
  value       = aws_api_gateway_integration.this.uri
}

output "credentials" {
  description = "The credentials required for the integration"
  value       = aws_api_gateway_integration.this.credentials
  sensitive   = true
}

output "request_templates" {
  description = "The integration's request templates"
  value       = aws_api_gateway_integration.this.request_templates
}

output "request_parameters" {
  description = "The request parameters"
  value       = aws_api_gateway_integration.this.request_parameters
}

output "passthrough_behavior" {
  description = "The integration passthrough behavior"
  value       = aws_api_gateway_integration.this.passthrough_behavior
}

output "cache_key_parameters" {
  description = "The cache key parameters for the integration"
  value       = aws_api_gateway_integration.this.cache_key_parameters
}

output "cache_namespace" {
  description = "The integration's cache namespace"
  value       = aws_api_gateway_integration.this.cache_namespace
}

output "content_handling" {
  description = "The content handling configuration"
  value       = aws_api_gateway_integration.this.content_handling
}

output "timeout_milliseconds" {
  description = "The custom timeout in milliseconds"
  value       = aws_api_gateway_integration.this.timeout_milliseconds
}

output "region" {
  description = "The region where the resource is managed"
  value       = aws_api_gateway_integration.this.region
}