output "function_arns" {
  description = "List of Lambda Function ARNs"
  value       = data.aws_lambda_functions.this.function_arns
}

output "function_names" {
  description = "List of Lambda Function names"
  value       = data.aws_lambda_functions.this.function_names
}