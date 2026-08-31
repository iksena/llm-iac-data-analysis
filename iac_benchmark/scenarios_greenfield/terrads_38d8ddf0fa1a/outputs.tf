output "execution_arn" {
  description = "Apigateway execution_arn"

  value = aws_apigatewayv2_api.this.execution_arn
}

output "id" {
  description = "Apigateway id"

  value = aws_apigatewayv2_api.this.id
}

output "name" {
  description = "Apigateway name"

  value = local.apigateway_name
}

output "authorizer_id" {
  value = length(aws_apigatewayv2_authorizer.this) > 0 ? aws_apigatewayv2_authorizer.this[0].id : null
}
