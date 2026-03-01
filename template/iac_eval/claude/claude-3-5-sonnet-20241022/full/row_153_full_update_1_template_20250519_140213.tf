I'll help you create a Terraform configuration that sets up a Lambda function with an event source mapping from a DynamoDB table. This configuration will:

1. Create a DynamoDB table
2. Create a Lambda function
3. Create necessary IAM roles and policies
4. Set up the event source mapping between DynamoDB and Lambda

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "table_name" {
  description = "Name of the DynamoDB table"
  default     = "my-dynamodb-table"
}

variable "function_name" {
  description = "Name of the Lambda function"
  default     = "dynamodb-processor"
}

# DynamoDB table
resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_dynamodb_role"

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

# IAM policy for the Lambda role
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_dynamodb_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams"
        ]
        Resource = "${aws_dynamodb_table.table.stream_arn}"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Lambda function
resource "aws_lambda_function" "processor" {
  filename      = "lambda_function.zip"
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.table.name
    }
  }
}

# Event source mapping
resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_dynamodb_table.table.stream_arn
  function_name     = aws_lambda_function.processor.arn
  starting_position = "LATEST"

  depends_on = [
    aws_iam_role_policy.lambda_policy
  ]
}
</iac_template>

This Terraform configuration creates:

1. A DynamoDB table with stream enabled
2. An IAM role and policy for the Lambda function to access DynamoDB streams and CloudWatch logs
3. A Lambda function (Note: you'll need to provide the actual Lambda function code in a ZIP file named "lambda_function.zip")
4. An event source mapping that connects the DynamoDB stream to the Lambda function

The configuration uses the us-east-1 region and includes all necessary permissions. The DynamoDB table uses on-demand billing (PAY_PER_REQUEST) and has a simple schema with just an "id" attribute as the hash key.

To use this configuration:
1. Make sure you have your AWS credentials configured
2. Create your Lambda function code and zip it as "lambda_function.zip"
3. Run `terraform init` and `terraform apply`

Note that you'll need to provide the actual Lambda function code in a ZIP file named "lambda_function.zip" in the same directory as your Terraform configuration.