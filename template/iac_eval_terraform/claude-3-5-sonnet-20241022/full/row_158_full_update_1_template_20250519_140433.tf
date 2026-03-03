I'll help you create a Terraform configuration to deploy an AWS Lambda function that runs a JavaScript file "lambda.js". This configuration will include:

1. An IAM role and policy for Lambda execution
2. A Lambda function with basic Node.js code
3. CloudWatch Logs permissions for Lambda logging
4. Required provider configuration

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

# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  
  source {
    content  = <<EOF
exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));
    return {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!')
    };
};
EOF
    filename = "lambda.js"
  }
}

# Create Lambda function
resource "aws_lambda_function" "test_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "test_lambda_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Environment = "production"
    Function    = "test"
  }
}

# Add CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = 14
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role with the necessary permissions for Lambda execution
3. A Lambda function with a basic Node.js handler
4. A CloudWatch Log Group for Lambda logging
5. The necessary ZIP archive for the Lambda function code

The Lambda function includes a simple JavaScript handler that logs the incoming event and returns a "Hello from Lambda!" message. The function uses Node.js 18.x runtime and includes basic environment variables and tags.

To deploy this:
1. Save this configuration in a .tf file
2. Run `terraform init`
3. Run `terraform plan`
4. Run `terraform apply`

The Lambda function will be created with basic logging capabilities and the necessary IAM permissions. You can modify the Lambda code in the `content` section of the `archive_file` data source to include your actual Lambda function logic.