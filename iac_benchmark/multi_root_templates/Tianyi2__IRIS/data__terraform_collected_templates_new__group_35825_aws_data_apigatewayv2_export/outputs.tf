output "id" {
  description = "API identifier."
  value       = data.aws_apigatewayv2_export.this.id
}

output "body" {
  description = "The exported API definition."
  value       = data.aws_apigatewayv2_export.this.body
}