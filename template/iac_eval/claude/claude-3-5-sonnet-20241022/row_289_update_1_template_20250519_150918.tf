provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket with owner pays configuration
resource "aws_s3_bucket" "owner_pays_bucket" {
  bucket = "my-owner-pays-bucket-${random_string.suffix.result}"
}

# Create random suffix for unique bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.owner_pays_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.owner_pays_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure bucket public access block
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.owner_pays_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.owner_pays_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}