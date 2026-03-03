I'll help you create a Terraform configuration that sets up a Lambda function with a function URL. This configuration will:
1. Create an IAM role and policy for the Lambda function
2. Create a basic Lambda function with Python runtime
3. Create a Lambda function URL to provide HTTPS endpoint for the function

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider for us-east-1 region
2. Creates an IAM role with basic Lambda execution permissions
3. Creates a Lambda function with a simple Python handler that returns "Hello from Lambda!"
4. Creates a Lambda function URL with CORS configuration
5. Outputs the function URL

The configuration includes a local-exec provisioner that creates a basic Python Lambda function and zips it. In a production environment, you would typically have your Lambda function code prepared separately.

The Lambda function URL is configured with no authentication ("NONE") for simplicity, but you can change it to "AWS_IAM" if you need authenticated access.

To deploy this:
1. Initialize Terraform: `terraform init`
2. Apply the configuration: `terraform apply`

After deployment, you'll get the function URL as an output, which you can use to invoke the Lambda function via HTTPS requests.