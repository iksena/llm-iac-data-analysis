provider "aws" {
  region = "us-east-1"
}

# Variables
variable "stage_name" {
  default = "prod"
}

# S3 bucket for storing cat pictures
resource "aws_s3_bucket" "cat_pictures" {
  bucket = "cat-pictures-storage-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket_public_access_block" "cat_pictures" {
  bucket = aws_s3_bucket.cat_pictures.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_role" {
  name = "cat_service_lambda_role"

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

# IAM policy for Lambda to access S3 and CloudWatch Logs
resource "aws_iam_role_policy" "lambda_policy" {
  name = "cat_service_lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.cat_pictures.arn,
          "${aws_s3_bucket.cat_pictures.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["arn:aws:logs:*:*:*"]
      }
    ]
  })
}

# Lambda function for uploading pictures
resource "aws_lambda_function" "upload_picture" {
  filename      = "upload.zip"
  function_name = "upload_cat_picture"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_pictures.id
    }
  }
}

# Lambda function for getting random pictures
resource "aws_lambda_function" "get_random_picture" {
  filename      = "random.zip"
  function_name = "get_random_cat_picture"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_pictures.id
    }
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "cat_api" {
  name = "cat-picture-api"
}

# API Gateway resources
resource "aws_api_gateway_resource" "upload" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  parent_id   = aws_api_gateway_rest_api.cat_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_resource" "random" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  parent_id   = aws_api_gateway_rest_api.cat_api.root_resource_id
  path_part   = "random"
}

# API Gateway methods
resource "aws_api_gateway_method" "upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.upload.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "random_get" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.random.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway integrations
resource "aws_api_gateway_integration" "upload_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cat_api.id
  resource_id             = aws_api_gateway_resource.upload.id
  http_method             = aws_api_gateway_method.upload_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.upload_picture.invoke_arn
}

resource "aws_api_gateway_integration" "random_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cat_api.id
  resource_id             = aws_api_gateway_resource.random.id
  http_method             = aws_api_gateway_method.random_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_random_picture.invoke_arn
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "upload_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_picture.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.cat_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "random_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_random_picture.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.cat_api.execution_arn}/*/*"
}

# API Gateway deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  depends_on = [
    aws_api_gateway_integration.upload_integration,
    aws_api_gateway_integration.random_integration
  ]
}

# API Gateway stage
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  stage_name    = var.stage_name
}

# Output the API Gateway URL
output "api_url" {
  value = "${aws_api_gateway_stage.stage.invoke_url}"
}