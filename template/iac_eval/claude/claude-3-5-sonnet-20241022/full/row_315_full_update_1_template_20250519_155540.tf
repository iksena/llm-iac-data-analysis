I'll help you create a Terraform configuration that sets up an EventBridge rule to trigger a Lambda function on a daily schedule at 7 UTC. Here's what the configuration will include:

1. AWS Provider configuration
2. EventBridge (CloudWatch Events) rule with daily schedule
3. Lambda function with specified configuration
4. IAM role and policy for Lambda execution
5. EventBridge target configuration
6. Lambda permission for EventBridge invocation

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

This Terraform configuration creates all the necessary resources to set up a Lambda function that will be triggered daily at 7 UTC through EventBridge. The configuration includes:

1. AWS provider configuration for us-east-1 region
2. IAM role and policy attachment for Lambda execution
3. Lambda function with the specified configuration
4. EventBridge rule with daily schedule at 7 UTC
5. EventBridge target linking to the Lambda function
6. Lambda permission allowing EventBridge to invoke the function

Note that this configuration assumes:
- The Lambda function code is zipped and available at "./supplement/lambda_func.zip"
- You have appropriate AWS credentials configured
- You're deploying in the us-east-1 region (can be modified as needed)

The configuration is complete and deployable, with all necessary resources and permissions properly defined and linked together.