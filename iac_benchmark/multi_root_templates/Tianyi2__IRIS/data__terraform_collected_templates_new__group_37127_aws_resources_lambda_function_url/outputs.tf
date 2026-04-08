output "authorization_type" {
  description = "Type of authentication that the function URL uses"
  value       = aws_lambda_function_url.this.authorization_type
}

output "cors" {
  description = "Cross-origin resource sharing (CORS) settings for the function URL"
  value       = aws_lambda_function_url.this.cors
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function_url.this.function_arn
}

output "function_name" {
  description = "Name or ARN of the Lambda function"
  value       = aws_lambda_function_url.this.function_name
}

output "function_url" {
  description = "HTTP URL endpoint for the function in the format https://<url_id>.lambda-url.<region>.on.aws/"
  value       = aws_lambda_function_url.this.function_url
}

output "invoke_mode" {
  description = "How the Lambda function responds to an invocation"
  value       = aws_lambda_function_url.this.invoke_mode
}

output "qualifier" {
  description = "Alias name or $LATEST"
  value       = aws_lambda_function_url.this.qualifier
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_lambda_function_url.this.region
}

output "url_id" {
  description = "Generated ID for the endpoint"
  value       = aws_lambda_function_url.this.url_id
}