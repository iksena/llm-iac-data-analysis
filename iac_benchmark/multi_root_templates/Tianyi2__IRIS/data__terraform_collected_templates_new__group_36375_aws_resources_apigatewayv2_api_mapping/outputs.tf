output "id" {
  description = "API mapping identifier."
  value       = aws_apigatewayv2_api_mapping.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_apigatewayv2_api_mapping.this.region
}

output "api_id" {
  description = "API identifier."
  value       = aws_apigatewayv2_api_mapping.this.api_id
}

output "domain_name" {
  description = "Domain name."
  value       = aws_apigatewayv2_api_mapping.this.domain_name
}

output "stage" {
  description = "API stage."
  value       = aws_apigatewayv2_api_mapping.this.stage
}

output "api_mapping_key" {
  description = "The API mapping key."
  value       = aws_apigatewayv2_api_mapping.this.api_mapping_key
}