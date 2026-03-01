I'll help you create a Terraform configuration that sets up an EventBridge (CloudWatch Events) rule to trigger a Lambda function daily at 7 UTC. The configuration will include all necessary resources including IAM roles and permissions.

Description:
This Terraform configuration will create:
1. An AWS Lambda function with Python 3.12 runtime
2. An IAM role and policy for the Lambda function
3. An EventBridge rule that triggers daily at 7 UTC
4. An EventBridge target that connects the rule to the Lambda function
5. Lambda permission to allow EventBridge to invoke the function

<iac_template>
# Configure AWS Provider
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

# Attach basic Lambda execution policy to the role
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
resource "aws_lambda_permission" "cron" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cron.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron.arn
}
</iac_template>

This configuration creates all the necessary resources to run a Lambda function on a daily schedule at 7 UTC. Note that you'll need to have the Lambda function code zipped and available at "./supplement/lambda_func.zip" before applying this configuration.

The EventBridge rule uses a cron expression "cron(0 7 * * ? *)" which translates to "every day at 7:00 UTC". The Lambda function is given the necessary permissions through an IAM role, and EventBridge is given permission to invoke the Lambda function through the Lambda permission resource.

All resources are properly linked together, and the configuration includes all necessary dependencies. The AWS provider is set to use the us-east-1 region, but you can modify this as needed for your use case.