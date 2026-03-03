I'll help you create a Terraform configuration to deploy an AWS Lambda function with the necessary IAM roles and permissions. This configuration will:

1. Create an IAM role for the Lambda function
2. Attach necessary IAM policies to the role
3. Create a Lambda function using the specified JavaScript file
4. Set up basic Lambda configuration with timeout and memory settings

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

  timeout     = 30
  memory_size = 128

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role that Lambda can assume
3. Attaches the AWSLambdaBasicExecutionRole policy to the IAM role (provides basic Lambda permissions including CloudWatch Logs access)
4. Creates a ZIP archive from your lambda.js file
5. Creates a Lambda function with:
   - 128MB of memory
   - 30-second timeout
   - Node.js 18.x runtime
   - Basic environment variable setup

To use this configuration:

1. Make sure you have a file named "lambda.js" in the same directory as your Terraform configuration
2. The lambda.js file should export a handler function
3. Make sure you have AWS credentials configured
4. Run `terraform init` followed by `terraform apply`

Note: The lambda.js file should exist in your local directory and should contain a valid Node.js Lambda function with a handler export. For example:

```javascript
exports.handler = async (event) => {
    // Your Lambda function code here
    return {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!')
    };
};
```