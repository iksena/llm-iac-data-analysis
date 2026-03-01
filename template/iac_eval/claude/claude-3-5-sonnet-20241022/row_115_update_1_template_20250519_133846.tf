provider "aws" {
  region = "us-west-2"
}

# Variables
variable "bucket_suffix" {
  description = "Suffix to append to bucket names"
  type        = string
  default     = "test"
}

# CloudGoat data storage bucket
resource "aws_s3_bucket" "cloudgoat_data" {
  bucket = "cloudgoat-data-${var.bucket_suffix}"
}

resource "aws_s3_bucket_ownership_controls" "cloudgoat_ownership" {
  bucket = aws_s3_bucket.cloudgoat_data.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "cloudgoat_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.cloudgoat_ownership]

  bucket = aws_s3_bucket.cloudgoat_data.id
  acl    = "private"
}

# Web data storage bucket
resource "aws_s3_bucket" "web_data" {
  bucket = "web-data-${var.bucket_suffix}"
}

resource "aws_s3_bucket_ownership_controls" "web_ownership" {
  bucket = aws_s3_bucket.web_data.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# Upload object to web data bucket
resource "aws_s3_object" "order_data" {
  bucket = aws_s3_bucket.web_data.id
  key    = "order_data2.csv"
  source = "order_data2.csv"  # Make sure this file exists in your local directory
}

# Public access block settings for web data bucket
resource "aws_s3_bucket_public_access_block" "web_access_block" {
  bucket = aws_s3_bucket.web_data.id

  ignore_public_acls      = true
  block_public_acls      = true
  restrict_public_buckets = true
  block_public_policy    = false  # Allow bucket policies
}

# Bucket policy for web data bucket
resource "aws_s3_bucket_policy" "web_bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.web_access_block]
  bucket = aws_s3_bucket.web_data.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPutObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.web_data.arn}/*"
      }
    ]
  })
}