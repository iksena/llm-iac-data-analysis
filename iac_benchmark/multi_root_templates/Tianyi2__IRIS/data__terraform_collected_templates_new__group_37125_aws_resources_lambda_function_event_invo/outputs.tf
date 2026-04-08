output "id" {
  description = "Fully qualified Lambda Function name or ARN"
  value       = aws_lambda_function_event_invoke_config.this.id
}