resource "aws_lambda_function" "s3_webserver_buckets" {
  filename      = "lambda/s3_webserver_buckets.zip"
  function_name = "s3_webserver_buckets"
  role          = aws_iam_role.s3_webserver_buckets_role.arn
  handler       = "s3_webserver_buckets.lambda_handler"
  timeout       = var.lambda_timeout

  runtime = "python3.7"
}

resource "aws_lambda_permission" "s3_webserver_buckets_config_permissions" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_webserver_buckets.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}

resource "aws_lambda_function" "iam_console_login" {
  filename      = "lambda/iam_console_login.zip"
  function_name = "iam_console_login"
  role          = aws_iam_role.iam_console_login_role.arn
  handler       = "iam_console_login.lambda_handler"
  timeout       = var.lambda_timeout

  runtime = "python3.7"
}

