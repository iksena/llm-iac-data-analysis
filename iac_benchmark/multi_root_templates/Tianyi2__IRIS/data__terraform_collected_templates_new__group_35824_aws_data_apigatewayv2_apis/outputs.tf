output "ids" {
  description = "Set of API identifiers."
  value       = data.aws_apigatewayv2_apis.this.ids
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_apigatewayv2_apis.this.region
}

output "name" {
  description = "API name filter used."
  value       = data.aws_apigatewayv2_apis.this.name
}

output "protocol_type" {
  description = "API protocol filter used."
  value       = data.aws_apigatewayv2_apis.this.protocol_type
}

output "tags" {
  description = "Map of tags filter used."
  value       = data.aws_apigatewayv2_apis.this.tags
}