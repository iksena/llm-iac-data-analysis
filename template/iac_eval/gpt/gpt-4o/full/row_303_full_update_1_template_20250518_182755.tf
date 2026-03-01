To accomplish the business need of creating a web service that allows users to upload cat pictures and provides random cat pictures on demand, we will use AWS API Gateway, AWS S3, and AWS Lambda. The architecture will include:

1. **AWS S3**: A bucket to store cat pictures.
2. **AWS Lambda**: Two Lambda functions:
   - One for uploading cat pictures to the S3 bucket.
   - Another for retrieving a random cat picture from the S3 bucket.
3. **AWS API Gateway**: To expose HTTP endpoints for uploading and retrieving cat pictures.
4. **IAM Roles**: Necessary roles and policies to allow Lambda functions to interact with S3.

The Terraform configuration will define these resources and their interactions.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cat_pictures" {
  bucket = "cat-pictures-bucket-123456"
  acl    = "private"
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
          "${aws_s3_bucket.cat_pictures.arn}",
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

resource "aws_lambda_function" "upload_cat_picture" {
  function_name = "upload_cat_picture"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "upload.handler"
  runtime       = "python3.8"

  filename = "lambda_upload.zip"

  source_code_hash = filebase64sha256("lambda_upload.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_pictures.bucket
    }
  }
}

resource "aws_lambda_function" "get_random_cat_picture" {
  function_name = "get_random_cat_picture"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "get_random.handler"
  runtime       = "python3.8"

  filename = "lambda_get_random.zip"

  source_code_hash = filebase64sha256("lambda_get_random.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_pictures.bucket
    }
  }
}

resource "aws_api_gateway_rest_api" "cat_api" {
  name        = "CatPicturesAPI"
  description = "API for uploading and retrieving cat pictures"
}

resource "aws_api_gateway_resource" "upload_resource" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  parent_id   = aws_api_gateway_rest_api.cat_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_method" "upload_method" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.upload_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "upload_integration" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  resource_id = aws_api_gateway_resource.upload_resource.id
  http_method = aws_api_gateway_method.upload_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.upload_cat_picture.invoke_arn
}

resource "aws_api_gateway_resource" "get_random_resource" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  parent_id   = aws_api_gateway_rest_api.cat_api.root_resource_id
  path_part   = "random"
}

resource "aws_api_gateway_method" "get_random_method" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.get_random_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_random_integration" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  resource_id = aws_api_gateway_resource.get_random_resource.id
  http_method = aws_api_gateway_method.get_random_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.get_random_cat_picture.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_upload" {
  statement_id  = "AllowAPIGatewayInvokeUpload"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_cat_picture.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.cat_api.execution_arn}/*/POST/upload"
}

resource "aws_lambda_permission" "api_gateway_get_random" {
  statement_id  = "AllowAPIGatewayInvokeGetRandom"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_random_cat_picture.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.cat_api.execution_arn}/*/GET/random"
}

resource "aws_api_gateway_deployment" "cat_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.upload_integration,
    aws_api_gateway_integration.get_random_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  stage_name  = "prod"
}
```
</iac_template>

This configuration sets up the necessary AWS resources to create a web service for uploading and retrieving cat pictures. The Lambda functions are assumed to be packaged in `lambda_upload.zip` and `lambda_get_random.zip`, which should contain the code for handling uploads and retrieving random images, respectively.