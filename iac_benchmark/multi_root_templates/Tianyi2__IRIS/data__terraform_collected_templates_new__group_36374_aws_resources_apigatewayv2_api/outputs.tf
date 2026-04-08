output "id" {
  description = "API identifier."
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "URI of the API, of the form https://{api-id}.execute-api.{region}.amazonaws.com for HTTP APIs and wss://{api-id}.execute-api.{region}.amazonaws.com for WebSocket APIs."
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "arn" {
  description = "ARN of the API."
  value       = aws_apigatewayv2_api.this.arn
}

output "execution_arn" {
  description = "ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_apigatewayv2_api.this.tags_all
}