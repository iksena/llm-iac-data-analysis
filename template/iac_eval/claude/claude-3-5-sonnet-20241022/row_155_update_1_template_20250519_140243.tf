provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "scheduled_lambda_role"

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

# Attach basic Lambda execution policy to the role
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
    print("Lambda function executed")
    return {
        'statusCode': 200,
        'body': 'Function executed successfully'
    }
EOF
    filename = "lambda_function.py"
  }
}

# Create Lambda function
resource "aws_lambda_function" "scheduled_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "scheduled_lambda_function"
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

# Create CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "every_fifteen_minutes" {
  name                = "every-fifteen-minutes"
  description         = "Triggers every fifteen minutes"
  schedule_expression = "rate(15 minutes)"
}

# Set Lambda function as target for the CloudWatch Event Rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_fifteen_minutes.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.scheduled_lambda.arn
}

# Add permission for CloudWatch to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_fifteen_minutes.arn
}