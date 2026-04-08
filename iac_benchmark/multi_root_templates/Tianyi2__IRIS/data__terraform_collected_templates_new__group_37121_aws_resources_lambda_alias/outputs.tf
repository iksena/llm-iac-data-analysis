output "arn" {
  description = "ARN identifying your Lambda function alias"
  value       = aws_lambda_alias.this.arn
}

output "invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_alias.this.invoke_arn
}

output "name" {
  description = "Name of the alias"
  value       = aws_lambda_alias.this.name
}

output "function_name" {
  description = "Name or ARN of the Lambda function"
  value       = aws_lambda_alias.this.function_name
}

output "function_version" {
  description = "Lambda function version for which the alias was created"
  value       = aws_lambda_alias.this.function_version
}

output "description" {
  description = "Description of the alias"
  value       = aws_lambda_alias.this.description
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_lambda_alias.this.region
}