output "function_arn" {
  description = "ARN of the function"
  value       = aws_lambda_runtime_management_config.this.function_arn
}