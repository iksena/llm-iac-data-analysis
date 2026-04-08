output "ids" {
  description = "List of Authorizer identifiers."
  value       = data.aws_api_gateway_authorizers.this.ids
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_api_gateway_authorizers.this.region
}

output "rest_api_id" {
  description = "ID of the associated REST API."
  value       = data.aws_api_gateway_authorizers.this.rest_api_id
}