To create an AWS Lambda function using Terraform, we will define a configuration that includes the AWS provider, an IAM role with the necessary permissions for the Lambda function, and the Lambda function itself. The Lambda function will be created using a file named "lambda.js" which should be uploaded to an S3 bucket. The Terraform configuration will include the creation of this S3 bucket, the IAM role, and the Lambda function. We will also specify the necessary permissions for the Lambda function to execute.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-function-bucket-123456"
  acl    = "private"
}

resource "aws_s3_bucket_object" "lambda_object" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda.js"
  source = "path/to/your/lambda.js"
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
  description = "IAM policy for Lambda execution"
  policy      = jsonencode({
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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_bucket_object.lambda_object.key
  handler       = "lambda.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.lambda_exec_role.arn
}
```
</iac_template>

This configuration will create an S3 bucket to store the Lambda function code, an IAM role with the necessary permissions for the Lambda function to execute and log to CloudWatch, and the Lambda function itself. Make sure to replace `"path/to/your/lambda.js"` with the actual path to your `lambda.js` file.