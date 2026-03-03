provider "aws" {
  region = "us-west-2"
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

# Create Lambda function
resource "aws_lambda_function" "example" {
  filename         = "lambda_function_payload.zip"
  function_name    = "example_lambda_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
  publish         = true

  # Example environment variables
  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }
}

# Create Lambda alias
resource "aws_lambda_alias" "example_alias" {
  name             = "production"
  description      = "Production alias for example lambda"
  function_name    = aws_lambda_function.example.function_name
  function_version = aws_lambda_function.example.version
}

# Local variable for the dummy Lambda function code
resource "local_file" "lambda_function" {
  filename = "lambda_function_payload.zip"
  content_base64 = "UEsDBAoAAAAAAONZbVYAAAAAAAAAAAAAAAAQAAAAbGFtYmRhX2Z1bmN0aW9uL1BLAwQKAAAAAADjWW1WAAAAAAAAAAAAAAAAGQAAAGxhbWJkYV9mdW5jdGlvbi9pbmRleC5qc1BLAQIUAAoAAAAAAONZbVYAAAAAAAAAAAAAAAAQAAAAAAAAAAAAEAAAAAAAAABsYW1iZGFfZnVuY3Rpb24vUEsBAhQACgAAAAAA41ltVgAAAAAAAAAAAAAAABkAAAAAAAAAAAAQAAAAOAAAAGxhbWJkYV9mdW5jdGlvbi9pbmRleC5qc1BLBQYAAAAAAgACAH4AAAB7AAAAAAA="
}

# Output the alias ARN
output "lambda_alias_arn" {
  value = aws_lambda_alias.example_alias.arn
}