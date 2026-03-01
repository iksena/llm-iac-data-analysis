I'll help you create a Terraform configuration that creates an AWS Lambda function and sets up its invocation. The configuration will include:

1. AWS Provider configuration
2. IAM role and policy for Lambda execution
3. Lambda function with a basic Python code
4. Lambda function invocation using the aws_lambda_invocation resource

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Creates an IAM role with the necessary permissions for Lambda execution
3. Creates a simple Python Lambda function that returns a "Hello from Lambda!" message
4. Packages the Lambda function code into a ZIP file
5. Creates the Lambda function with the specified configuration
6. Invokes the Lambda function with some example input
7. Outputs the result of the Lambda invocation

The Lambda function is a simple Python function that returns a success status code and a greeting message. The function is invoked with some example JSON input, and the result is made available as a Terraform output.

To deploy this configuration:
1. Save it to a .tf file
2. Run `terraform init`
3. Run `terraform plan`
4. Run `terraform apply`

The configuration includes all necessary components and should deploy successfully in your AWS account.