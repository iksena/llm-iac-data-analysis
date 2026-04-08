output "api_endpoint" {
  description = "URI of the API, of the form https://{api-id}.execute-api.{region}.amazonaws.com for HTTP APIs and wss://{api-id}.execute-api.{region}.amazonaws.com for WebSocket APIs."
  value       = data.aws_apigatewayv2_api.this.api_endpoint
}

output "api_key_selection_expression" {
  description = "An API key selection expression. Applicable for WebSocket APIs."
  value       = data.aws_apigatewayv2_api.this.api_key_selection_expression
}

output "arn" {
  description = "ARN of the API."
  value       = data.aws_apigatewayv2_api.this.arn
}

output "cors_configuration" {
  description = "Cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs."
  value       = data.aws_apigatewayv2_api.this.cors_configuration
}

output "description" {
  description = "Description of the API."
  value       = data.aws_apigatewayv2_api.this.description
}

output "disable_execute_api_endpoint" {
  description = "Whether clients can invoke the API by using the default execute-api endpoint."
  value       = data.aws_apigatewayv2_api.this.disable_execute_api_endpoint
}

output "execution_arn" {
  description = "ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = data.aws_apigatewayv2_api.this.execution_arn
}

output "name" {
  description = "Name of the API."
  value       = data.aws_apigatewayv2_api.this.name
}

output "protocol_type" {
  description = "API protocol."
  value       = data.aws_apigatewayv2_api.this.protocol_type
}

output "route_selection_expression" {
  description = "The route selection expression for the API."
  value       = data.aws_apigatewayv2_api.this.route_selection_expression
}

output "tags" {
  description = "Map of resource tags."
  value       = data.aws_apigatewayv2_api.this.tags
}

output "version" {
  description = "Version identifier for the API."
  value       = data.aws_apigatewayv2_api.this.version
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_apigatewayv2_api.this.region
}

output "api_id" {
  description = "API identifier."
  value       = data.aws_apigatewayv2_api.this.api_id
}