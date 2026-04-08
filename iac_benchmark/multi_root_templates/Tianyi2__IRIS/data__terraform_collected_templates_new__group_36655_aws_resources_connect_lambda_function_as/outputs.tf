output "id" {
  description = "The Amazon Connect instance ID and Lambda Function ARN separated by a comma (`,`)."
  value       = aws_connect_lambda_function_association.this.id
}