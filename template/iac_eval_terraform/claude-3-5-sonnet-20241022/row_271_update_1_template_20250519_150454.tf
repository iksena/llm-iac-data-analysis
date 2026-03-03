provider "aws" {
  region = "us-east-1"
}

# Create primary S3 bucket
resource "aws_s3_bucket" "primary" {
  bucket = "mybucket"
}

# Create analytics destination bucket
resource "aws_s3_bucket" "analytics_destination" {
  bucket = "mybucket-analytics-destination"
}

# Enable versioning for analytics destination bucket
resource "aws_s3_bucket_versioning" "analytics_destination" {
  bucket = aws_s3_bucket.analytics_destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create bucket policy for analytics destination bucket
resource "aws_s3_bucket_policy" "analytics_destination" {
  bucket = aws_s3_bucket.analytics_destination.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAnalyticsDestination"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.analytics_destination.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.primary.arn
          }
        }
      }
    ]
  })
}

# Configure analytics for primary bucket
resource "aws_s3_bucket_analytics_configuration" "primary_analytics" {
  bucket = aws_s3_bucket.primary.id
  name   = "EntireBucketAnalytics"

  storage_class_analysis {
    data_export {
      destination {
        s3_bucket_destination {
          bucket_arn = aws_s3_bucket.analytics_destination.arn
          prefix     = "analytics-results"
        }
      }
    }
  }
}

# Block public access for primary bucket
resource "aws_s3_bucket_public_access_block" "primary" {
  bucket = aws_s3_bucket.primary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for analytics destination bucket
resource "aws_s3_bucket_public_access_block" "analytics_destination" {
  bucket = aws_s3_bucket.analytics_destination.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}