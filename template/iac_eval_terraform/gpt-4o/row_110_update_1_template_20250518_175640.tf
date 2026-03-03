provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "source_bucket" {
  bucket = "a"

  logging {
    target_bucket = "logging-680235478471"
    target_prefix = "log/"
  }
}

resource "aws_iam_role" "s3_logging_role" {
  name = "s3_logging_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_logging_policy" {
  name        = "s3_logging_policy"
  description = "Policy to allow S3 bucket logging"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::logging-680235478471/log/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_logging_role_attachment" {
  role       = aws_iam_role.s3_logging_role.name
  policy_arn = aws_iam_policy.s3_logging_policy.arn
}

resource "aws_s3_bucket_policy" "source_bucket_policy" {
  bucket = aws_s3_bucket.source_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.s3_logging_role.arn
        }
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::logging-680235478471/log/*"
      }
    ]
  })
}