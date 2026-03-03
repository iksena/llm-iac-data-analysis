provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kendra_role" {
  name = "KendraDataSourceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "kendra_policy" {
  name        = "KendraDataSourcePolicy"
  description = "Policy for Kendra data source access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kendra_policy_attach" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = aws_iam_policy.kendra_policy.arn
}

resource "aws_kendra_data_source" "example" {
  name        = "example-data-source"
  index_id    = "your-kendra-index-id" # Replace with your Kendra index ID
  type        = "S3"
  role_arn    = aws_iam_role.kendra_role.arn

  s3_configuration {
    bucket_name = "your-s3-bucket-name" # Replace with your S3 bucket name
  }

  proxy_configuration {
    host     = "proxy.example.com" # Replace with your proxy host
    port     = 8080                # Replace with your proxy port
    username = "proxyuser"         # Replace with your proxy username
    password = "proxypassword"     # Replace with your proxy password
  }
}