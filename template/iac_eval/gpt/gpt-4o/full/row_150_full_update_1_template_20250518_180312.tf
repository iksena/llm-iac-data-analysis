To fulfill the business need, we will create a Terraform configuration that sets up an AWS Lambda function and a corresponding Lambda function URL. The configuration will include the necessary IAM role and policy to allow the Lambda function to execute. The Lambda function will be named "example_lambda" and will be deployed in the "us-east-1" region. The Lambda function URL will be configured to allow public access.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "example_lambda_exec_role"

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
  name        = "example_lambda_exec_policy"
  description = "IAM policy for Lambda execution"

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

resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  filename = "lambda_function_payload.zip"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_lambda_function_url" "example_lambda_url" {
  function_name = aws_lambda_function.example_lambda.function_name
  authorization_type = "NONE"
}
```
</iac_template>

This configuration includes:
- An AWS IAM role with a policy that allows the Lambda function to write logs to CloudWatch.
- An AWS Lambda function named "example_lambda" with a Node.js 14.x runtime.
- A Lambda function URL resource that allows public access to the Lambda function. 

Make sure to have the `lambda_function_payload.zip` file in the same directory as your Terraform configuration, containing the code for the Lambda function.