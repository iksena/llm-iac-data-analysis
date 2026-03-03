To fulfill the business need, we will create an AWS Lambda function named `test_lambda` that will be triggered by an Amazon CloudWatch Event Rule. This rule will listen for the specific event of an EC2 image creation. The Lambda function will be granted the necessary permissions to be invoked by the CloudWatch Event. We will also set up the necessary IAM roles and policies to allow the Lambda function to execute properly.

Here is the Terraform configuration that sets up the required infrastructure:

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

resource "aws_lambda_function" "test_lambda" {
  function_name = "test_lambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  filename = "lambda_function_payload.zip"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_cloudwatch_event_rule" "ec2_image_creation_rule" {
  name        = "ec2_image_creation_rule"
  description = "Trigger Lambda on EC2 image creation"
  event_pattern = jsonencode({
    source = ["aws.ec2"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["ec2.amazonaws.com"]
      eventName   = ["CreateImage"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.ec2_image_creation_rule.name
  target_id = "test_lambda"
  arn       = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_image_creation_rule.arn
}
```
</iac_template>

This configuration includes:
- An IAM role for the Lambda function with the necessary trust policy.
- An IAM policy allowing the Lambda function to write logs to CloudWatch.
- A Lambda function named `test_lambda` with a placeholder for the code package.
- A CloudWatch Event Rule that triggers on EC2 image creation.
- A CloudWatch Event Target to link the rule to the Lambda function.
- A Lambda permission to allow CloudWatch Events to invoke the Lambda function.