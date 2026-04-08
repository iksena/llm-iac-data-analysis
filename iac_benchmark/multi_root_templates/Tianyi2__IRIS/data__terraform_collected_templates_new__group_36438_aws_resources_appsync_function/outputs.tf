output "id" {
  description = "API Function ID (Formatted as ApiId-FunctionId)"
  value       = aws_appsync_function.this.id
}

output "arn" {
  description = "ARN of the Function object."
  value       = aws_appsync_function.this.arn
}

output "function_id" {
  description = "Unique ID representing the Function object."
  value       = aws_appsync_function.this.function_id
}