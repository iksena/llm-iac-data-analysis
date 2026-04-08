resource "aws_cloudwatch_log_group" "lambda_log" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.retention_in_days
}
