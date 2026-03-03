provider "aws" {
  region = "us-east-1"
}

# Create main S3 bucket
resource "aws_s3_bucket" "main" {
  bucket = "mybucket"
}

# Create bucket for inventory reports
resource "aws_s3_bucket" "inventory" {
  bucket = "mybucket-inventory"
}

# Create bucket policy for inventory bucket
resource "aws_s3_bucket_policy" "inventory" {
  bucket = aws_s3_bucket.inventory.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3BucketInventory"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = [
          "${aws_s3_bucket.inventory.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.main.arn
          }
        }
      }
    ]
  })
}

# Enable versioning on inventory bucket
resource "aws_s3_bucket_versioning" "inventory" {
  bucket = aws_s3_bucket.inventory.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure inventory for main bucket
resource "aws_s3_bucket_inventory" "main" {
  bucket = aws_s3_bucket.main.id
  name   = "daily-inventory"

  included_object_versions = "All"

  schedule {
    frequency = "Daily"
  }

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = aws_s3_bucket.inventory.arn
    }
  }

  optional_fields = [
    "Size",
    "LastModifiedDate",
    "StorageClass",
    "ETag",
    "IsMultipartUploaded",
    "ReplicationStatus"
  ]
}

# Block public access for main bucket
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for inventory bucket
resource "aws_s3_bucket_public_access_block" "inventory" {
  bucket = aws_s3_bucket.inventory.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}