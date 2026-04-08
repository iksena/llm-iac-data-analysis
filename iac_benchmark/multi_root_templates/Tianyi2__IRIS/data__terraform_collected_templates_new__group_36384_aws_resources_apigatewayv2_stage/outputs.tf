output "id" {
  description = "Stage identifier"
  value       = aws_apigatewayv2_stage.this.id
}

output "arn" {
  description = "ARN of the stage"
  value       = aws_apigatewayv2_stage.this.arn
}

output "execution_arn" {
  description = "ARN prefix to be used in an aws_lambda_permission's source_arn attribute"
  value       = aws_apigatewayv2_stage.this.execution_arn
}

output "invoke_url" {
  description = "URL to invoke the API pointing to the stage"
  value       = aws_apigatewayv2_stage.this.invoke_url
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_apigatewayv2_stage.this.tags_all
}