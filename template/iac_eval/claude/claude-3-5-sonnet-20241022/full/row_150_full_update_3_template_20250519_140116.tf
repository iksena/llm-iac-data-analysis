I'll provide a simplified and corrected version of the template. Let me wrap it in the requested tags:

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_role" {
  name = "example_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "example_lambda" {
  filename      = "lambda_function.zip"
  function_name = "example_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
}

resource "aws_lambda_function_url" "example_url" {
  function_name      = aws_lambda_function.example_lambda.function_name
  authorization_type = "NONE"
}

output "lambda_function_url" {
  description = "The URL of the Lambda function"
  value       = aws_lambda_function_url.example_url.url
}
</iac_template>

This template:
1. Includes proper provider configuration
2. Creates an IAM role for Lambda
3. Attaches the basic Lambda execution policy
4. Creates a Lambda function (Note: you'll need to provide the lambda_function.zip file)
5. Creates a Lambda function URL
6. Outputs the function URL

The main changes from the previous version:
- Removed the complex CORS configuration
- Removed the archive_file data source
- Simplified the overall structure
- Added the requested template tags
- Kept only the essential configurations

Note: You'll need to provide a lambda_function.zip file containing your Lambda function code before applying this configuration.