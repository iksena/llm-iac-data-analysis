provider "aws" {
  region = "us-east-1"
}

# IAM role for Lambda
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

# Basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Lambda function
resource "aws_lambda_function" "example_lambda" {
  filename      = "lambda_function.zip"
  function_name = "example_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"

  # Create a dummy ZIP file with basic Python handler
  provisioner "local-exec" {
    command = <<EOT
echo 'def handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from Lambda!"
    }' > index.py
zip lambda_function.zip index.py
EOT
  }
}

# Lambda function URL
resource "aws_lambda_function_url" "example_url" {
  function_name      = aws_lambda_function.example_lambda.function_name
  authorization_type = "NONE"  # Public access, change to "AWS_IAM" for authenticated access

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age          = 86400
  }
}

# Output the function URL
output "lambda_function_url" {
  description = "The URL of the Lambda function"
  value       = aws_lambda_function_url.example_url.url
}