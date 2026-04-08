output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_api_gateway_authorizer.this.region
}

output "authorizer_id" {
  description = "Authorizer identifier."
  value       = data.aws_api_gateway_authorizer.this.authorizer_id
}

output "rest_api_id" {
  description = "ID of the associated REST API."
  value       = data.aws_api_gateway_authorizer.this.rest_api_id
}

output "arn" {
  description = "ARN of the API Gateway Authorizer."
  value       = data.aws_api_gateway_authorizer.this.arn
}

output "authorizer_credentials" {
  description = "Credentials required for the authorizer."
  value       = data.aws_api_gateway_authorizer.this.authorizer_credentials
}

output "authorizer_result_ttl_in_seconds" {
  description = "TTL of cached authorizer results in seconds."
  value       = data.aws_api_gateway_authorizer.this.authorizer_result_ttl_in_seconds
}

output "authorizer_uri" {
  description = "Authorizer's Uniform Resource Identifier (URI)."
  value       = data.aws_api_gateway_authorizer.this.authorizer_uri
}

output "identity_source" {
  description = "Source of the identity in an incoming request."
  value       = data.aws_api_gateway_authorizer.this.identity_source
}

output "identity_validation_expression" {
  description = "Validation expression for the incoming identity."
  value       = data.aws_api_gateway_authorizer.this.identity_validation_expression
}

output "name" {
  description = "Name of the authorizer."
  value       = data.aws_api_gateway_authorizer.this.name
}

output "provider_arns" {
  description = "List of the Amazon Cognito user pool ARNs."
  value       = data.aws_api_gateway_authorizer.this.provider_arns
}

output "type" {
  description = "Type of the authorizer."
  value       = data.aws_api_gateway_authorizer.this.type
}