provider "aws" {
  region = "us-east-1"
}

# Variables
variable "stage_name" {
  description = "API Gateway deployment stage name"
  default     = "prod"
}

# S3 bucket for storing cat pictures
resource "aws_s3_bucket" "cat_pictures" {
  bucket_prefix = "cat-pictures-"
}

resource "aws_s3_bucket_cors_configuration" "cat_pictures" {
  bucket = aws_s3_bucket.cat_pictures.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "cat_api" {
  name = "cat-pictures-api"
}

# API Gateway resource for /upload
resource "aws_api_gateway_resource" "upload" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  parent_id   = aws_api_gateway_rest_api.cat_api.root_resource_id
  path_part   = "upload"
}

# API Gateway resource for /random
resource "aws_api_gateway_resource" "random" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  parent_id   = aws_api_gateway_rest_api.cat_api.root_resource_id
  path_part   = "random"
}

# POST method for upload
resource "aws_api_gateway_method" "upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.upload.id
  http_method   = "POST"
  authorization = "NONE"
}

# GET method for random
resource "aws_api_gateway_method" "random_get" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.random.id
  http_method   = "GET"
  authorization = "NONE"
}

# IAM role for API Gateway
resource "aws_iam_role" "api_gateway_role" {
  name = "api_gateway_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for API Gateway to access S3
resource "aws_iam_role_policy" "api_gateway_s3_policy" {
  name = "api_gateway_s3_policy"
  role = aws_iam_role.api_gateway_role.id

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
      }
    ]
  })
}

# Integration for upload endpoint
resource "aws_api_gateway_integration" "upload_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cat_api.id
  resource_id             = aws_api_gateway_resource.upload.id
  http_method             = aws_api_gateway_method.upload_post.http_method
  integration_http_method = "PUT"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:s3:path/${aws_s3_bucket.cat_pictures.id}/{key}"
  credentials             = aws_iam_role.api_gateway_role.arn

  request_parameters = {
    "integration.request.path.key" = "method.request.querystring.key"
  }
}

# Integration for random endpoint
resource "aws_api_gateway_integration" "random_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cat_api.id
  resource_id             = aws_api_gateway_resource.random.id
  http_method             = aws_api_gateway_method.random_get.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:s3:path/${aws_s3_bucket.cat_pictures.id}"
  credentials             = aws_iam_role.api_gateway_role.arn
}

# Current region data source
data "aws_region" "current" {}

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