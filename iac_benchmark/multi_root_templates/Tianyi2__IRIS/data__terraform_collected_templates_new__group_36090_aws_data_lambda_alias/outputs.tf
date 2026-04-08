output "arn" {
  description = "ARN identifying the Lambda function alias"
  value       = data.aws_lambda_alias.this.arn
}

output "description" {
  description = "Description of the alias"
  value       = data.aws_lambda_alias.this.description
}

output "function_version" {
  description = "Lambda function version which the alias uses"
  value       = data.aws_lambda_alias.this.function_version
}

output "invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value       = data.aws_lambda_alias.this.invoke_arn
}

output "function_name" {
  description = "Name of the aliased Lambda function"
  value       = data.aws_lambda_alias.this.function_name
}

output "name" {
  description = "Name of the Lambda alias"
  value       = data.aws_lambda_alias.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lambda_alias.this.region
}