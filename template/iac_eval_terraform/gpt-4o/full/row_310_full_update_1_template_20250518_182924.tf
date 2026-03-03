To accomplish the task of running a code every day at 7 UTC using AWS EventBridge, we will create an EventBridge rule that triggers a Lambda function. The Lambda function will contain the code that needs to be executed. We will also set up the necessary IAM roles and policies to allow EventBridge to invoke the Lambda function.

Here's a description of the Terraform program:
1. **AWS Provider Configuration**: Set up the AWS provider to deploy resources in a specified region.
2. **IAM Role and Policy**: Create an IAM role with a policy that allows EventBridge to invoke the Lambda function.
3. **Lambda Function**: Define a simple Lambda function that will be triggered by the EventBridge rule.
4. **EventBridge Rule**: Create an EventBridge rule with a cron expression to trigger the Lambda function every day at 7 UTC.

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
  name                = "everyday_7am"
  description         = "Triggers Lambda function every day at 7 AM UTC"
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

This configuration sets up an AWS Lambda function that is triggered by an EventBridge rule every day at 7 AM UTC. The necessary IAM roles and policies are also created to allow the EventBridge service to invoke the Lambda function. The Lambda function's code should be packaged in a file named `lambda_function_payload.zip`.