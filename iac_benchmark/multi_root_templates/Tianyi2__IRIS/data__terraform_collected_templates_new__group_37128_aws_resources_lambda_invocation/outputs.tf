output "result" {
  description = "String result of the Lambda function invocation"
  value       = aws_lambda_invocation.this.result
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_invocation.this.function_name
}

output "input" {
  description = "JSON payload to the Lambda function"
  value       = aws_lambda_invocation.this.input
}

output "lifecycle_scope" {
  description = "Lifecycle scope of the resource to manage"
  value       = aws_lambda_invocation.this.lifecycle_scope
}

output "qualifier" {
  description = "Qualifier (i.e., version) of the Lambda function"
  value       = aws_lambda_invocation.this.qualifier
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_lambda_invocation.this.region
}

output "terraform_key" {
  description = "JSON key used to store lifecycle information in the input JSON payload"
  value       = aws_lambda_invocation.this.terraform_key
}

output "triggers" {
  description = "Map of arbitrary keys and values that trigger re-invocation"
  value       = aws_lambda_invocation.this.triggers
}