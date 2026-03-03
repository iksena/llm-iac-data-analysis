provider "aws" {
  region = "us-east-1"
}

# Create the logging bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-logging-bucket-${random_string.random_suffix.result}"
}

# Create the primary bucket
resource "aws_s3_bucket" "primary_bucket" {
  bucket = "my-primary-bucket-${random_string.random_suffix.result}"
}

# Generate random suffix for unique bucket names
resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enable versioning for log bucket
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning for primary bucket
resource "aws_s3_bucket_versioning" "primary_bucket_versioning" {
  bucket = aws_s3_bucket.primary_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure ACL for log bucket to allow logging
resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_ownership]
  bucket     = aws_s3_bucket.log_bucket.id
  acl        = "log-delivery-write"
}

# Configure logging from primary bucket to log bucket
resource "aws_s3_bucket_logging" "primary_bucket_logging" {
  bucket = aws_s3_bucket.primary_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Add bucket policies
resource "aws_s3_bucket_public_access_block" "log_bucket_access" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "primary_bucket_access" {
  bucket = aws_s3_bucket.primary_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}