I'll help you create a Terraform configuration for an AWS Lambda function with the necessary IAM roles, policies, and function code. Here's what we'll build:

1. AWS Lambda function with Node.js 18.x runtime
2. IAM role for the Lambda function
3. IAM policy document for role assumption
4. Lambda function code archive
5. Necessary IAM policy attachments

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

# Create ZIP archive for Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    content  = <<EOF
exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));
    return {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
};
EOF
    filename = "lambda.js"
  }
}

# Create Lambda function
resource "aws_lambda_function" "example_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "example_lambda_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "nodejs18.x"

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  timeout = 30
  memory_size = 128

  tags = {
    Environment = "production"
    Function    = "example"
  }
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role with an assume role policy that allows Lambda to assume the role
3. An IAM policy attachment that provides basic Lambda execution permissions
4. A ZIP archive containing the Lambda function code (a simple Node.js function)
5. A Lambda function that:
   - Uses Node.js 18.x runtime
   - Has a timeout of 30 seconds
   - Uses 128MB of memory
   - Includes basic environment variables and tags
   - Uses the handler "lambda.handler"
   - References the created IAM role
   - Uses the ZIP archive as its source code

The Lambda function code is a simple example that logs the incoming event and returns a "Hello from Lambda!" message. The configuration is complete and deployable, with all necessary components included.