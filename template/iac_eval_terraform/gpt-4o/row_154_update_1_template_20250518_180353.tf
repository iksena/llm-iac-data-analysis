provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "lambda_layer_bucket" {
  bucket = "my-lambda-layer-bucket-123456"
  acl    = "private"
}

resource "aws_s3_bucket_object" "lambda_layer_zip" {
  bucket = aws_s3_bucket.lambda_layer_bucket.id
  key    = "lambda_layer_payload.zip"
  source = "lambda_layer_payload.zip"
}

resource "aws_iam_role" "lambda_execution_role" {
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

resource "aws_iam_policy" "lambda_s3_access_policy" {
  name        = "lambda_s3_access_policy"
  description = "Policy to allow Lambda to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.lambda_layer_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_access_policy.arn
}

resource "aws_lambda_layer_version" "my_lambda_layer" {
  layer_name          = "my_lambda_layer"
  s3_bucket           = aws_s3_bucket.lambda_layer_bucket.id
  s3_key              = aws_s3_bucket_object.lambda_layer_zip.id
  compatible_runtimes = ["python3.8"]
}