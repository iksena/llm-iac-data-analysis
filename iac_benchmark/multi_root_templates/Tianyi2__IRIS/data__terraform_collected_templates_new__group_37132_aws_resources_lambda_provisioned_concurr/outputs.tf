output "id" {
  description = "Lambda Function name and qualifier separated by a comma (,)"
  value       = aws_lambda_provisioned_concurrency_config.this.id
}

output "function_name" {
  description = "Name or Amazon Resource Name (ARN) of the Lambda Function"
  value       = aws_lambda_provisioned_concurrency_config.this.function_name
}

output "provisioned_concurrent_executions" {
  description = "Amount of capacity to allocate"
  value       = aws_lambda_provisioned_concurrency_config.this.provisioned_concurrent_executions
}

output "qualifier" {
  description = "Lambda Function version or Lambda Alias name"
  value       = aws_lambda_provisioned_concurrency_config.this.qualifier
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_lambda_provisioned_concurrency_config.this.region
}

output "skip_destroy" {
  description = "Whether to retain the provisioned concurrency configuration upon destruction"
  value       = aws_lambda_provisioned_concurrency_config.this.skip_destroy
}