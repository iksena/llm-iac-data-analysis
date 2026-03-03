To create a Lambda function alias using Terraform, we need to define a Lambda function and then create an alias for it. The alias will point to a specific version of the Lambda function. We will use the AWS provider to manage the resources. The configuration will include the Lambda function, a version for the function, and an alias that points to this version. We will also create an IAM role with the necessary permissions for the Lambda function to execute.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
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

resource "aws_iam_policy" "lambda_exec_policy" {
  name        = "lambda_exec_policy"
  description = "IAM policy for Lambda execution"

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

resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_lambda_function_version" "version" {
  function_name = aws_lambda_function.my_lambda.function_name
}

resource "aws_lambda_alias" "my_lambda_alias" {
  name             = "my_lambda_alias"
  function_name    = aws_lambda_function.my_lambda.function_name
  function_version = aws_lambda_function_version.version.version
}
```
</iac_template>

This configuration includes:

- An AWS provider configured for the `us-east-1` region.
- An IAM role and policy for the Lambda function to allow it to write logs to CloudWatch.
- A Lambda function resource with a specified handler and runtime.
- A Lambda function version resource to create a version of the Lambda function.
- A Lambda alias resource that points to the created version of the Lambda function.