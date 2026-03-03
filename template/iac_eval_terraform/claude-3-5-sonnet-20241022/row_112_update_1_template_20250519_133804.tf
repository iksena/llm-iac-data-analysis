provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with object lock enabled
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"

  # Object lock must be enabled at bucket creation
  object_lock_enabled = true

  # Force destroy must be false when using object lock
  force_destroy = false
}

# Enable versioning (required for object lock)
resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure object lock
resource "aws_s3_bucket_object_lock_configuration" "example_bucket_lock" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 30
    }
  }
}

# Configure public access block for security
resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}