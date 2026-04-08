output "id" {
  description = "Route response identifier."
  value       = aws_apigatewayv2_route_response.this.id
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_apigatewayv2_route_response.this.region
}

output "api_id" {
  description = "API identifier."
  value       = aws_apigatewayv2_route_response.this.api_id
}

output "route_id" {
  description = "Identifier of the aws_apigatewayv2_route."
  value       = aws_apigatewayv2_route_response.this.route_id
}

output "route_response_key" {
  description = "Route response key."
  value       = aws_apigatewayv2_route_response.this.route_response_key
}

output "model_selection_expression" {
  description = "The model selection expression for the route response."
  value       = aws_apigatewayv2_route_response.this.model_selection_expression
}

output "response_models" {
  description = "Response models for the route response."
  value       = aws_apigatewayv2_route_response.this.response_models
}