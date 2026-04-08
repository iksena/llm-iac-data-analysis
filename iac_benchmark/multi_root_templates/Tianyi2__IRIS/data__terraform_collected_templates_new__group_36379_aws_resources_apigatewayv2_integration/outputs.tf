output "id" {
  description = "Integration identifier."
  value       = aws_apigatewayv2_integration.this.id
}

output "integration_response_selection_expression" {
  description = "The integration response selection expression for the integration."
  value       = aws_apigatewayv2_integration.this.integration_response_selection_expression
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_apigatewayv2_integration.this.region
}

output "api_id" {
  description = "API identifier."
  value       = aws_apigatewayv2_integration.this.api_id
}

output "integration_type" {
  description = "Integration type of an integration."
  value       = aws_apigatewayv2_integration.this.integration_type
}

output "connection_id" {
  description = "ID of the VPC link for a private integration."
  value       = aws_apigatewayv2_integration.this.connection_id
}

output "connection_type" {
  description = "Type of the network connection to the integration endpoint."
  value       = aws_apigatewayv2_integration.this.connection_type
}

output "content_handling_strategy" {
  description = "How to handle response payload content type conversions."
  value       = aws_apigatewayv2_integration.this.content_handling_strategy
}

output "credentials_arn" {
  description = "Credentials required for the integration, if any."
  value       = aws_apigatewayv2_integration.this.credentials_arn
}

output "description" {
  description = "Description of the integration."
  value       = aws_apigatewayv2_integration.this.description
}

output "integration_method" {
  description = "Integration's HTTP method."
  value       = aws_apigatewayv2_integration.this.integration_method
}

output "integration_subtype" {
  description = "AWS service action to invoke."
  value       = aws_apigatewayv2_integration.this.integration_subtype
}

output "integration_uri" {
  description = "URI of the Lambda function for a Lambda proxy integration."
  value       = aws_apigatewayv2_integration.this.integration_uri
}

output "passthrough_behavior" {
  description = "Pass-through behavior for incoming requests based on the Content-Type header in the request."
  value       = aws_apigatewayv2_integration.this.passthrough_behavior
}

output "payload_format_version" {
  description = "The format of the payload sent to an integration."
  value       = aws_apigatewayv2_integration.this.payload_format_version
}

output "request_parameters" {
  description = "Request parameters that are passed from the method request to the backend."
  value       = aws_apigatewayv2_integration.this.request_parameters
}

output "request_templates" {
  description = "Map of Velocity templates that are applied on the request payload based on the value of the Content-Type header sent by the client."
  value       = aws_apigatewayv2_integration.this.request_templates
}

output "response_parameters" {
  description = "Mappings to transform the HTTP response from a backend integration before returning the response to clients."
  value       = aws_apigatewayv2_integration.this.response_parameters
}

output "template_selection_expression" {
  description = "The template selection expression for the integration."
  value       = aws_apigatewayv2_integration.this.template_selection_expression
}

output "timeout_milliseconds" {
  description = "Custom timeout between 50 and 29,000 milliseconds for WebSocket APIs and between 50 and 30,000 milliseconds for HTTP APIs."
  value       = aws_apigatewayv2_integration.this.timeout_milliseconds
}

output "tls_config" {
  description = "TLS configuration for a private integration."
  value       = aws_apigatewayv2_integration.this.tls_config
}