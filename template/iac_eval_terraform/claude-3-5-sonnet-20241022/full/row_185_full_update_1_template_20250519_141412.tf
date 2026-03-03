I'll help you create a Terraform configuration for an AWS Lambda function with the specified requirements. This configuration will include:

1. An AWS Lambda function with Node.js 18.x runtime
2. An IAM role and policy for Lambda execution
3. A CloudWatch Log Group for Lambda logs
4. The necessary provider configuration

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

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/my_nodejs_function"
  retention_in_days = 14
}

# Create Lambda function
resource "aws_lambda_function" "nodejs_function" {
  filename         = "lambda.js"
  function_name    = "my_nodejs_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  source_code_hash = filebase64sha256("lambda.js")
  runtime         = "nodejs18.x"

  environment {
    variables = {
      NODE_ENV = "production"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_cloudwatch_log_group.lambda_log_group
  ]
}
</iac_template>

This Terraform configuration creates all necessary resources for running a Lambda function:

1. AWS Provider is configured for the us-east-1 region
2. An IAM role with the necessary trust relationship for Lambda
3. The AWS Lambda basic execution policy is attached to the role
4. A CloudWatch Log Group for Lambda logs with 14-day retention
5. The Lambda function itself with Node.js 18.x runtime

Note: You need to ensure that the "lambda.js" file exists in the same directory as your Terraform configuration when you apply this template. The file should contain your Lambda function code with an exported handler function in "index.js".

The Lambda function will have basic execution permissions including the ability to create CloudWatch logs. If your Lambda function needs additional permissions (e.g., to access other AWS services), you would need to attach additional IAM policies to the role.