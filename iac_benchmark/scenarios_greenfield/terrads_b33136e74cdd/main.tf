resource "aws_lambda_function" "start_ecs_service" {
  depends_on = [
    aws_cloudwatch_log_group.strt_ecs_services,
    aws_iam_role.role,
  ]
  function_name    = "start-ecs-service-scheduler"
  handler          = "start_lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "./src/lambda_function_start.zip"
  source_code_hash = data.archive_file.start_lambda.output_base64sha256
  role             = aws_iam_role.role.arn
  timeout          = 60

  tracing_config {
    mode = "Active"
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.strt_ecs_services.name
  }

  environment {
    variables = {
      bucket_name = aws_s3_bucket.ecs_services_scheduler.id
    }
  }

  tags = local.tags
}

resource "aws_lambda_function" "stop_ecs_service" {
  depends_on = [
    aws_cloudwatch_log_group.stop_ecs_services,
    aws_iam_role.role,
  ]
  function_name    = "stop-ecs-service-scheduler"
  handler          = "stop_lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "./src/lambda_function_stop.zip"
  source_code_hash = data.archive_file.stop_lambda.output_base64sha256
  role             = aws_iam_role.role.arn
  timeout          = 120

  tracing_config {
    mode = "Active"
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.stop_ecs_services.name
  }

  environment {
    variables = {
      bucket_name = aws_s3_bucket.ecs_services_scheduler.id
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_event_rule" "start_lambda" {
  name                = "start-ecs-lambda"
  description         = "Rule triggering start function for ECS Services"
  schedule_expression = "cron(0 6 ? * mon-fri *)"
}

resource "aws_cloudwatch_event_rule" "stop_lambda" {
  name                = "stop-ecs-lambda"
  description         = "Rule triggering stop function for ECS Services"
  schedule_expression = "cron(0 16 ? * mon-fri *)"
}

resource "aws_cloudwatch_event_target" "start_lambda_target" {
  rule      = aws_cloudwatch_event_rule.start_lambda.name
  target_id = aws_lambda_function.start_ecs_service.function_name
  arn       = aws_lambda_function.start_ecs_service.arn
}

resource "aws_cloudwatch_event_target" "stop_ecs_service" {
  rule      = aws_cloudwatch_event_rule.stop_lambda.name
  target_id = aws_lambda_function.stop_ecs_service.function_name
  arn       = aws_lambda_function.stop_ecs_service.arn
}

resource "aws_lambda_permission" "start_lambda_target" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ecs_service.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_lambda.arn
}

resource "aws_lambda_permission" "stop_ecs_service" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ecs_service.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_lambda.arn
}
