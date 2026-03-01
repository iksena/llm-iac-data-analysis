provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for cat pictures
resource "aws_s3_bucket" "cat_pictures" {
  bucket = "caas-cat-pictures-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# DynamoDB table for cat metadata
resource "aws_dynamodb_table" "cat_metadata" {
  name           = "cat_metadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "name"

  attribute {
    name = "name"
    type = "S"
  }
}

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_role" {
  name = "caas_lambda_role"

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

# IAM policy for Lambda functions
resource "aws_iam_role_policy" "lambda_policy" {
  name = "caas_lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
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
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.cat_metadata.arn
      }
    ]
  })
}

# Lambda functions
resource "aws_lambda_function" "get_cat" {
  filename      = "get_cat.zip"
  function_name = "caas_get_cat"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_pictures.id
      TABLE_NAME  = aws_dynamodb_table.cat_metadata.name
    }
  }
}

resource "aws_lambda_function" "put_cat" {
  filename      = "put_cat.zip"
  function_name = "caas_put_cat"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_pictures.id
      TABLE_NAME  = aws_dynamodb_table.cat_metadata.name
    }
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "caas" {
  name        = "caas"
  description = "Cat as a Service API"
}

resource "aws_api_gateway_resource" "caas_cat" {
  rest_api_id = aws_api_gateway_rest_api.caas.id
  parent_id   = aws_api_gateway_rest_api.caas.root_resource_id
  path_part   = "cat"
}

# GET method
resource "aws_api_gateway_method" "caas_get" {
  rest_api_id   = aws_api_gateway_rest_api.caas.id
  resource_id   = aws_api_gateway_resource.caas_cat.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.caas.id
  resource_id             = aws_api_gateway_resource.caas_cat.id
  http_method             = aws_api_gateway_method.caas_get.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.get_cat.invoke_arn
}

# PUT method
resource "aws_api_gateway_method" "caas_put" {
  rest_api_id   = aws_api_gateway_rest_api.caas.id
  resource_id   = aws_api_gateway_resource.caas_cat.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "put_integration" {
  rest_api_id             = aws_api_gateway_rest_api.caas.id
  resource_id             = aws_api_gateway_resource.caas_cat.id
  http_method             = aws_api_gateway_method.caas_put.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.put_cat.invoke_arn
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "get_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_cat.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.caas.execution_arn}/*/*"
}

resource "aws_lambda_permission" "put_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_cat.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.caas.execution_arn}/*/*"
}

# API Gateway deployment
resource "aws_api_gateway_deployment" "caas" {
  rest_api_id = aws_api_gateway_rest_api.caas.id
  depends_on = [
    aws_api_gateway_integration.get_integration,
    aws_api_gateway_integration.put_integration
  ]
}

resource "aws_api_gateway_stage" "caas" {
  deployment_id = aws_api_gateway_deployment.caas.id
  rest_api_id   = aws_api_gateway_rest_api.caas.id
  stage_name    = "prod"
}