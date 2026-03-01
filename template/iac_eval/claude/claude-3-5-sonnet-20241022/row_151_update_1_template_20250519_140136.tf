provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
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

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = <<EOF
def handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda!'
    }
EOF
    filename = "lambda_function.py"
  }
}

# Create Lambda function
resource "aws_lambda_function" "example_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "example_lambda"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.9"

  environment {
    variables = {
      EXAMPLE_VAR = "example_value"
    }
  }
}

# Invoke Lambda function
resource "aws_lambda_invocation" "example_invoke" {
  function_name = aws_lambda_function.example_lambda.function_name
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
  })
}

# Output the result of the Lambda invocation
output "lambda_result" {
  value = jsondecode(aws_lambda_invocation.example_invoke.result)
}