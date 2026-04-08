output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function_recursion_config.this.function_name
}

output "recursive_loop" {
  description = "Lambda function recursion configuration"
  value       = aws_lambda_function_recursion_config.this.recursive_loop
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_lambda_function_recursion_config.this.region
}