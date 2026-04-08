output "arn" {
  description = "ARN of the API Gateway Stage"
  value       = aws_api_gateway_stage.this.arn
}

output "id" {
  description = "ID of the stage"
  value       = aws_api_gateway_stage.this.id
}

output "invoke_url" {
  description = "URL to invoke the API pointing to the stage"
  value       = aws_api_gateway_stage.this.invoke_url
}

output "execution_arn" {
  description = "Execution ARN to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function"
  value       = aws_api_gateway_stage.this.execution_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_api_gateway_stage.this.tags_all
}

output "web_acl_arn" {
  description = "ARN of the WebAcl associated with the Stage"
  value       = aws_api_gateway_stage.this.web_acl_arn
}