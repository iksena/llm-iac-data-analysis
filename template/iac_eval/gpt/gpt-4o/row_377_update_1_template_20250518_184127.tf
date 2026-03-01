provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "content_bucket" {
  bucket = "my-lightsail-content-bucket"
  acl    = "private"
}

resource "aws_iam_role" "lightsail_access_role" {
  name = "LightsailAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lightsail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lightsail_s3_access_policy" {
  name        = "LightsailS3AccessPolicy"
  description = "Policy to allow Lightsail Distribution to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.content_bucket.arn,
          "${aws_s3_bucket.content_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lightsail_access_role.name
  policy_arn = aws_iam_policy.lightsail_s3_access_policy.arn
}

resource "aws_lightsail_distribution" "my_distribution" {
  name = "my-lightsail-distribution"

  origin {
    name = aws_s3_bucket.content_bucket.bucket
    protocol_policy = "https-only"
  }

  default_cache_behavior {
    behavior = "cache"
  }
}