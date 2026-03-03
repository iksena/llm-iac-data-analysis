To fulfill the business need, we will create an AWS Lambda function using Terraform. The Lambda function will execute a JavaScript file named "lambda.js". We will also define the necessary IAM roles and policies to ensure that the Lambda function has the appropriate permissions to execute. The configuration will include the AWS provider setup, an S3 bucket to store the Lambda deployment package, and the Lambda function itself.

Here's the Terraform configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-deployment-bucket-123456"
  acl    = "private"
}

resource "aws_s3_bucket_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda.zip"
  source = "path/to/lambda.zip" # Ensure this path points to your local zip file containing lambda.js
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Policy for Lambda execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_bucket_object.lambda_zip.id
  handler       = "lambda.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.lambda_exec_role.arn
}
```
</iac_template>

This configuration sets up an S3 bucket to store the Lambda deployment package, creates an IAM role with the necessary permissions for the Lambda function to write logs to CloudWatch, and defines the Lambda function itself. Make sure to replace `"path/to/lambda.zip"` with the actual path to your zipped Lambda deployment package containing `lambda.js`.