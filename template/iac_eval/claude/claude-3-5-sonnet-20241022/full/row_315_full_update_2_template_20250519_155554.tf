I'll provide the template with proper tags and ensure all syntax is correct. This template creates an EventBridge rule that triggers a Lambda function daily at 7 UTC.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "cron_lambda_role"

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

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create Lambda function
resource "aws_lambda_function" "cron" {
  filename         = "./supplement/lambda_func.zip"
  function_name    = "cron-lambda-function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_func.lambda_handler"
  runtime         = "python3.12"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic
  ]
}

# Create EventBridge rule
resource "aws_cloudwatch_event_rule" "cron" {
  name                = "daily-lambda-trigger"
  description         = "Trigger Lambda function daily at 7 UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

# Create EventBridge target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.cron.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.cron.arn
}

# Create Lambda permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cron.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron.arn
}
</iac_template>