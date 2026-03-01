To meet the business need, we will create an AWS Lambda function using Terraform. The configuration will include an IAM role with a policy that allows the Lambda function to assume the role. We will also create an archive file for the Lambda function code, which will be written in Node.js 18. The Lambda function will have a specific handler defined, and the source file for the code will be "lambda.js". The configuration will be set up in the "us-east-1" region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda.js"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.handler"
  runtime       = "nodejs18.x"
  filename      = archive_file.lambda_zip.output_path

  source_code_hash = filebase64sha256(archive_file.lambda_zip.output_path)
}
```
</iac_template>

This Terraform configuration sets up an AWS Lambda function with the necessary IAM role and policy, and packages the Lambda function code into a zip archive. The Lambda function is configured to use the Node.js 18 runtime and specifies "lambda.handler" as the handler function.