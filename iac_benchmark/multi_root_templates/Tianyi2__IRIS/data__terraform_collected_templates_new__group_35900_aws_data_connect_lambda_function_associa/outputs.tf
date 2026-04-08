output "id" {
  description = "AWS Region."
  value       = data.aws_connect_lambda_function_association.this.id
}

output "function_arn" {
  description = "ARN of the Lambda Function, omitting any version or alias qualifier."
  value       = data.aws_connect_lambda_function_association.this.function_arn
}

output "instance_id" {
  description = "Identifier of the Amazon Connect instance."
  value       = data.aws_connect_lambda_function_association.this.instance_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_connect_lambda_function_association.this.region
}