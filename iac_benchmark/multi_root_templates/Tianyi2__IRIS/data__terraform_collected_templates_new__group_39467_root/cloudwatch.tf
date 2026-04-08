resource "aws_cloudwatch_log_group" "s3_webserver_buckets_cloudwatch" {
  name              = "/aws/lambda/${aws_lambda_function.s3_webserver_buckets.function_name}"
  retention_in_days = 14
}

