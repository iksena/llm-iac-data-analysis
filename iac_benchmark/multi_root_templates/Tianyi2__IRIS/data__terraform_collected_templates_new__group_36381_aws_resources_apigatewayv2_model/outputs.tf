output "id" {
  description = "Model identifier."
  value       = aws_apigatewayv2_model.this.id
}

output "api_id" {
  description = "API identifier."
  value       = aws_apigatewayv2_model.this.api_id
}

output "content_type" {
  description = "The content-type for the model."
  value       = aws_apigatewayv2_model.this.content_type
}

output "name" {
  description = "Name of the model."
  value       = aws_apigatewayv2_model.this.name
}

output "schema" {
  description = "Schema for the model."
  value       = aws_apigatewayv2_model.this.schema
}

output "description" {
  description = "Description of the model."
  value       = aws_apigatewayv2_model.this.description
}