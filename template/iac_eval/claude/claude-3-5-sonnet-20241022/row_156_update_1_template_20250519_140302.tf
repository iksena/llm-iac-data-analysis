provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "test_lambda_role"

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
resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "test_lambda"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  
  # Create empty Lambda function
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Create CloudWatch Event rule
resource "aws_cloudwatch_event_rule" "ami_creation" {
  name        = "capture-ami-creation"
  description = "Capture all EC2 AMI creation events"

  event_pattern = jsonencode({
    source      = ["aws.ec2"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["ec2.amazonaws.com"]
      eventName   = ["CreateImage"]
    }
  })
}

# Create CloudWatch Event target
resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.ami_creation.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.test_lambda.arn
}

# Add Lambda permission to allow CloudWatch Events to invoke the function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ami_creation.arn
}

# Local file for Lambda function code (you need to create this file)
resource "local_file" "lambda_function" {
  filename = "lambda_function.zip"
  content_base64 = base64encode(<<EOF
import json

def handler(event, context):
    print("Received event: " + json.dumps(event))
    return {
        'statusCode': 200,
        'body': json.dumps('AMI Creation detected!')
    }
EOF
  )
}