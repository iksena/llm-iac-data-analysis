output "result" {
  description = "String result of the Lambda function invocation"
  value       = data.aws_lambda_invocation.this.result
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = data.aws_lambda_invocation.this.function_name
}

output "input" {
  description = "String in JSON format that is passed as payload to the Lambda function"
  value       = data.aws_lambda_invocation.this.input
}

output "qualifier" {
  description = "Qualifier (a.k.a version) of the Lambda function"
  value       = data.aws_lambda_invocation.this.qualifier
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lambda_invocation.this.region
}