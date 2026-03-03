provider "aws" {
  region = "us-east-1"
}

# Lambda IAM role
resource "aws_iam_role" "lambda_role" {
  name = "daily_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda basic execution policy attachment
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Lambda function
resource "aws_lambda_function" "daily_function" {
  filename      = "lambda_function.zip"
  function_name = "daily_task"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"

  # Create an empty ZIP file with a basic Python handler
  provisioner "local-exec" {
    command = <<EOT
echo 'def handler(event, context):
    print("Daily task executed")
    return {
        "statusCode": 200,
        "body": "Success"
    }' > /tmp/index.py
cd /tmp && zip lambda_function.zip index.py
EOT
  }
}

# EventBridge rule
resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "daily-trigger"
  description         = "Triggers Lambda function daily at 7 UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

# EventBridge target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.daily_function.arn
}

# Lambda permission to allow EventBridge to invoke the function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}