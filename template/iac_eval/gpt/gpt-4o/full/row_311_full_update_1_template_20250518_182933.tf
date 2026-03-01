To accomplish the task of running a code every day at 7 UTC using AWS services, we will set up an AWS Lambda function that contains the code to be executed. We will then use AWS EventBridge to create a scheduled rule that triggers the Lambda function at the specified time. Additionally, we will create the necessary IAM role and policy to allow EventBridge to invoke the Lambda function.

Here's the Terraform configuration to achieve this:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_execution_role" {
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

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Policy for Lambda execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  filename = "lambda_function_payload.zip"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_cloudwatch_event_rule" "everyday_7am" {
  name        = "everyday_7am"
  description = "Triggers Lambda function every day at 7 AM UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.everyday_7am.name
  target_id = "my_lambda"
  arn       = aws_lambda_function.my_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.everyday_7am.arn
}
```
</iac_template>

This configuration sets up a Lambda function that is triggered every day at 7 AM UTC by an EventBridge rule. The necessary IAM roles and policies are created to allow the Lambda function to log to CloudWatch and to be invoked by EventBridge. Make sure to replace `lambda_function_payload.zip` with the actual path to your Lambda function's deployment package.