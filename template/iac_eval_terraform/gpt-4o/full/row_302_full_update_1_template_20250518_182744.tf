To fulfill the business need, we will create an AWS infrastructure using Terraform that includes an S3 bucket to store cat pictures, an API Gateway to handle HTTP requests, and a Lambda function to process these requests. The Lambda function will allow users to upload cat pictures to the S3 bucket and retrieve random cat pictures. We will also set up the necessary IAM roles and policies to ensure that the Lambda function has the required permissions to interact with the S3 bucket.

Here's the Terraform configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cat_pictures" {
  bucket = "cat-pictures-bucket-123456"
  acl    = "private"

  versioning {
    enabled = true
  }
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

resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda_s3_policy"
  description = "Policy for Lambda to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.cat_pictures.arn,
          "${aws_s3_bucket.cat_pictures.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

resource "aws_lambda_function" "cat_pictures_handler" {
  function_name = "cat_pictures_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_pictures.bucket
    }
  }
}

resource "aws_api_gateway_rest_api" "cat_pictures_api" {
  name        = "CatPicturesAPI"
  description = "API for uploading and retrieving cat pictures"
}

resource "aws_api_gateway_resource" "cat_pictures_resource" {
  rest_api_id = aws_api_gateway_rest_api.cat_pictures_api.id
  parent_id   = aws_api_gateway_rest_api.cat_pictures_api.root_resource_id
  path_part   = "catpictures"
}

resource "aws_api_gateway_method" "cat_pictures_method" {
  rest_api_id   = aws_api_gateway_rest_api.cat_pictures_api.id
  resource_id   = aws_api_gateway_resource.cat_pictures_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cat_pictures_integration" {
  rest_api_id = aws_api_gateway_rest_api.cat_pictures_api.id
  resource_id = aws_api_gateway_resource.cat_pictures_resource.id
  http_method = aws_api_gateway_method.cat_pictures_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.cat_pictures_handler.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cat_pictures_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.cat_pictures_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "cat_pictures_deployment" {
  depends_on = [aws_api_gateway_integration.cat_pictures_integration]
  rest_api_id = aws_api_gateway_rest_api.cat_pictures_api.id
  stage_name  = "prod"
}
```
</iac_template>

This configuration sets up an S3 bucket for storing cat pictures, a Lambda function to handle uploads and retrievals, and an API Gateway to expose the functionality via HTTP endpoints. The necessary IAM roles and policies are also configured to allow the Lambda function to interact with the S3 bucket.