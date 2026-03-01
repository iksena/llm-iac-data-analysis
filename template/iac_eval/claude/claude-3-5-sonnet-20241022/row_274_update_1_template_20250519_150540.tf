provider "aws" {
  region = "us-east-1"
}

# Create main S3 bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket = "main-data-bucket-${random_string.random_suffix.result}"
}

resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create inventory destination bucket
resource "aws_s3_bucket" "inventory_bucket" {
  bucket = "inventory-bucket-${random_string.random_suffix.result}"
}

resource "aws_s3_bucket_versioning" "inventory_bucket_versioning" {
  bucket = aws_s3_bucket.inventory_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Generate random suffix for bucket names
resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create IAM role for inventory
resource "aws_iam_role" "inventory_role" {
  name = "s3-inventory-role"

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

# Create IAM policy for inventory
resource "aws_iam_role_policy" "inventory_policy" {
  name = "s3-inventory-policy"
  role = aws_iam_role.inventory_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.inventory_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Create bucket policy for inventory bucket
resource "aws_s3_bucket_policy" "inventory_bucket_policy" {
  bucket = aws_s3_bucket.inventory_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "InventoryPolicy"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.inventory_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.main_bucket.arn
          }
        }
      }
    ]
  })
}

# Configure S3 inventory
resource "aws_s3_bucket_inventory" "inventory_config" {
  bucket = aws_s3_bucket.main_bucket.id
  name   = "weekly-inventory"

  schedule {
    frequency = "Weekly"
  }

  included_object_versions = "Current"

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = aws_s3_bucket.inventory_bucket.arn
    }
  }

  optional_fields = [
    "Size",
    "LastModifiedDate",
    "StorageClass",
    "ETag",
    "IsMultipartUploaded",
    "ReplicationStatus",
    "EncryptionStatus"
  ]
}