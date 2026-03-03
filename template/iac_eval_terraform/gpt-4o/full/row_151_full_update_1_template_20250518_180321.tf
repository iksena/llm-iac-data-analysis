To fulfill the business need, we will create an AWS Lambda function named "example_lambda" using Terraform. This Lambda function will be written in Python and will be triggered by an AWS CloudWatch Event Rule. The CloudWatch Event Rule will be set up to invoke the Lambda function on a schedule (e.g., every 5 minutes). We will also create the necessary IAM role and policy to allow the Lambda function to execute. The Terraform configuration will include the AWS provider setup, the Lambda function resource, the IAM role and policy, and the CloudWatch Event Rule.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_role" {
  name = "example_lambda_role"

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
  name        = "example_lambda_policy"
  description = "Policy for example_lambda"

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
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      EXAMPLE_ENV_VAR = "example_value"
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name        = "every_five_minutes"
  description = "Triggers example_lambda every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "example_lambda"
  arn       = aws_lambda_function.example_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}
```

</iac_template>

This configuration sets up an AWS Lambda function named "example_lambda" that is triggered every 5 minutes by a CloudWatch Event Rule. The necessary IAM role and policy are created to allow the Lambda function to execute and log to CloudWatch Logs. The Lambda function code should be packaged into a ZIP file named `lambda_function_payload.zip` and placed in the same directory as the Terraform configuration.