To accomplish the task of running a code every day at 7 UTC using AWS services, we will set up an AWS Lambda function that will be triggered by an AWS EventBridge event rule. The EventBridge rule will be configured to trigger the Lambda function at the specified time. We will also set up the necessary permissions for the EventBridge rule to invoke the Lambda function. The following resources will be created:

1. **AWS Lambda Function**: This will contain the code that needs to be executed.
2. **AWS EventBridge Rule**: This will define the schedule to trigger the Lambda function every day at 7 UTC.
3. **AWS EventBridge Target**: This will link the EventBridge rule to the Lambda function.
4. **AWS Lambda Permission**: This will allow the EventBridge rule to invoke the Lambda function.

The configuration will include the necessary IAM roles and policies to allow the Lambda function to execute and be triggered by EventBridge.

```hcl
<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
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

resource "aws_iam_policy" "lambda_exec_policy" {
  name        = "lambda_exec_policy"
  description = "Policy for Lambda execution"
  policy      = jsonencode({
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

resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  filename      = "lambda_function_payload.zip"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_cloudwatch_event_rule" "everyday_7am" {
  name        = "everyday_7am"
  description = "Triggers Lambda function every day at 7 AM UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.everyday_7am.name
  target_id = "my_lambda_target"
  arn       = aws_lambda_function.my_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.everyday_7am.arn
}
</iac_template>
```

This configuration sets up a Lambda function that will be triggered every day at 7 AM UTC by an EventBridge rule. The necessary IAM roles and permissions are also configured to ensure the Lambda function can be executed and logs can be written to CloudWatch. The Lambda function code should be packaged in a file named `lambda_function_payload.zip`.