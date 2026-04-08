output "id" {
  description = "Integration response identifier."
  value       = aws_apigatewayv2_integration_response.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_apigatewayv2_integration_response.this.region
}

output "api_id" {
  description = "API identifier."
  value       = aws_apigatewayv2_integration_response.this.api_id
}

output "integration_id" {
  description = "Identifier of the aws_apigatewayv2_integration."
  value       = aws_apigatewayv2_integration_response.this.integration_id
}

output "integration_response_key" {
  description = "Integration response key."
  value       = aws_apigatewayv2_integration_response.this.integration_response_key
}

output "content_handling_strategy" {
  description = "How to handle response payload content type conversions."
  value       = aws_apigatewayv2_integration_response.this.content_handling_strategy
}

output "response_templates" {
  description = "Map of Velocity templates that are applied on the request payload."
  value       = aws_apigatewayv2_integration_response.this.response_templates
}

output "template_selection_expression" {
  description = "The template selection expression for the integration response."
  value       = aws_apigatewayv2_integration_response.this.template_selection_expression
}