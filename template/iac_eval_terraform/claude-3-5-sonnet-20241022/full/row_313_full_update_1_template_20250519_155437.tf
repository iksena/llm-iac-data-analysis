I'll help you create a Terraform configuration for an AWS EventBridge (CloudWatch Events) rule that triggers a Lambda function daily at 7 UTC. The configuration will include:

1. An AWS Lambda function using the provided deployment package
2. An EventBridge rule with a cron schedule
3. Required IAM roles and policies for both Lambda and EventBridge
4. Necessary permissions for EventBridge to invoke the Lambda function

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

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

# Create Lambda function
resource "aws_lambda_function" "scheduled_lambda" {
  filename         = "./supplement/lambda_func.zip"
  function_name    = "scheduled_lambda_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"  # Adjust based on your function's runtime

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }
}

# Create EventBridge rule
resource "aws_cloudwatch_event_rule" "cron" {
  name                = "cron"
  description         = "Trigger Lambda function daily at 7 UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

# Create EventBridge target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.cron.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.scheduled_lambda.arn
}

# Grant EventBridge permission to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron.arn
}
</iac_template>

This Terraform configuration creates:
1. An IAM role for the Lambda function with basic execution permissions
2. A Lambda function using the provided deployment package
3. An EventBridge rule that runs daily at 7 UTC
4. The necessary target configuration to connect the EventBridge rule to the Lambda function
5. Required permissions for EventBridge to invoke the Lambda function

Note: Make sure that:
- The Lambda deployment package exists at "./supplement/lambda_func.zip"
- Adjust the Lambda runtime if your function uses a different runtime
- The AWS provider region is appropriate for your needs
- You have appropriate AWS credentials configured

The EventBridge rule will trigger the Lambda function every day at 7:00 UTC using the cron expression "cron(0 7 * * ? *)".