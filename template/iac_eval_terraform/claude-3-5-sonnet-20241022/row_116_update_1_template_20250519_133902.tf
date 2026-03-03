terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Random string to ensure bucket name uniqueness
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-unique-bucket-${random_string.random.result}"
}

# S3 Bucket ACL
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  bucket     = aws_s3_bucket.website_bucket.id
  acl        = "private"
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
        Condition = {
          StringLike = {
            "aws:Referer" = ["http://example.com/*"]
          }
        }
      }
    ]
  })
}

# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}