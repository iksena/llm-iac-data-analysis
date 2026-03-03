I'll provide a cleaner template with proper formatting and syntax. Please find the improved version below:

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

# Attach basic Lambda execution policy to the role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Archive the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda.js"
  output_path = "lambda.zip"
}

# Create Lambda function
resource "aws_lambda_function" "example_lambda" {
  filename         = "lambda.zip"
  function_name    = "example_lambda_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "nodejs18.x"
  timeout         = 30
  memory_size     = 128

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }
}
</iac_template>

This template includes:
1. AWS provider configuration
2. IAM role creation for Lambda with necessary assume role policy
3. IAM policy attachment for basic Lambda execution
4. Archive creation for the Lambda function code
5. Lambda function resource with all necessary configurations

The template assumes that:
- You have AWS credentials configured
- The file "lambda.js" exists in the same directory as your Terraform configuration
- The Lambda function handler is defined in lambda.js
- The Lambda function will run on Node.js 18.x runtime

The Lambda function is configured with:
- 128MB of memory
- 30 seconds timeout
- An environment variable ENVIRONMENT set to "production"
- Basic execution role permissions