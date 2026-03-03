To fulfill the business need, we will create an AWS Lambda function and set up an Amazon CloudWatch Events rule to trigger the Lambda function every 15 minutes. The Lambda function will be created using a simple Python script, and the necessary IAM roles and permissions will be configured to allow the Lambda function to execute and be triggered by the CloudWatch Events rule.

Here's the Terraform configuration to achieve this:

1. **AWS Provider Configuration**: Set up the AWS provider to deploy resources in a specific region.
2. **IAM Role and Policy**: Create an IAM role with a policy that allows Lambda execution.
3. **Lambda Function**: Define a Lambda function using a basic Python script.
4. **CloudWatch Events Rule**: Create a CloudWatch Events rule to trigger the Lambda function every 15 minutes.
5. **Lambda Permission**: Grant permission for the CloudWatch Events rule to invoke the Lambda function.

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

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_execution_role.id
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

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  filename = "lambda_function_payload.zip"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "null_resource" "lambda_zip" {
  provisioner "local-exec" {
    command = <<EOT
      echo 'def lambda_handler(event, context):' > lambda_function.py
      echo '    print("Hello from Lambda!")' >> lambda_function.py
      zip lambda_function_payload.zip lambda_function.py
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "aws_cloudwatch_event_rule" "every_15_minutes" {
  name        = "every_15_minutes"
  description = "Triggers Lambda function every 15 minutes"
  schedule_expression = "rate(15 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_15_minutes.name
  target_id = "my_lambda"
  arn       = aws_lambda_function.my_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_15_minutes.arn
}
```
</iac_template>

This configuration will create a Lambda function that prints "Hello from Lambda!" and is triggered every 15 minutes by a CloudWatch Events rule. The necessary IAM roles and permissions are also configured to allow the Lambda function to execute and be invoked by the CloudWatch Events rule.