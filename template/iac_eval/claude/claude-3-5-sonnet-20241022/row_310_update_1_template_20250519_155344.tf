provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
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

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = <<EOF
def lambda_handler(event, context):
    print("Daily task executed at 7 UTC")
    return {
        'statusCode': 200,
        'body': 'Daily task completed successfully'
    }
EOF
    filename = "lambda_function.py"
  }
}

# Create Lambda function
resource "aws_lambda_function" "daily_task" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "daily_task_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.9"

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }
}

# Create EventBridge rule
resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "daily-task-trigger"
  description         = "Triggers Lambda function daily at 7 UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

# Set Lambda function as target for the EventBridge rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "DailyLambdaFunction"
  arn       = aws_lambda_function.daily_task.arn
}

# Add permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_task.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}