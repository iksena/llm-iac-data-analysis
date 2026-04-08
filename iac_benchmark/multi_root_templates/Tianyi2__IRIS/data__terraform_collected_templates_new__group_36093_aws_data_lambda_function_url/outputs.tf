output "function_name" {
  description = "Name or ARN of the Lambda function"
  value       = data.aws_lambda_function_url.this.function_name
}

output "qualifier" {
  description = "Alias name or $LATEST"
  value       = data.aws_lambda_function_url.this.qualifier
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lambda_function_url.this.region
}

output "authorization_type" {
  description = "Type of authentication that the function URL uses"
  value       = data.aws_lambda_function_url.this.authorization_type
}

output "cors" {
  description = "Cross-origin resource sharing (CORS) settings for the function URL"
  value       = data.aws_lambda_function_url.this.cors
}

output "creation_time" {
  description = "When the function URL was created, in ISO-8601 format"
  value       = data.aws_lambda_function_url.this.creation_time
}

output "function_arn" {
  description = "ARN of the function"
  value       = data.aws_lambda_function_url.this.function_arn
}

output "function_url" {
  description = "HTTP URL endpoint for the function in the format https://<url_id>.lambda-url.<region>.on.aws/"
  value       = data.aws_lambda_function_url.this.function_url
}

output "invoke_mode" {
  description = "Whether the Lambda function responds in BUFFERED or RESPONSE_STREAM mode"
  value       = data.aws_lambda_function_url.this.invoke_mode
}

output "last_modified_time" {
  description = "When the function URL configuration was last updated, in ISO-8601 format"
  value       = data.aws_lambda_function_url.this.last_modified_time
}

output "url_id" {
  description = "Generated ID for the endpoint"
  value       = data.aws_lambda_function_url.this.url_id
}