output "function_name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.demo_lambda.function_name
}

output "api_gateway_endpoint" {
  description = "Base URL for API Gateway stage."
  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "s3_bucket_name" {
  description = "The bucket name for store the lambda function"
  value = aws_s3_bucket.lambda_bucket.id
}

output "lambda_function_name" {
  description = "The lambda function name"
  value = aws_lambda_function.demo_lambda.function_name
}
