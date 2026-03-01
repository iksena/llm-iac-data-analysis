provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with object lock enabled
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"

  # Object Lock must be enabled at bucket creation
  object_lock_enabled = true

  # Force destroy must be set to true if you want to delete the bucket with locked objects
  force_destroy = true
}

# Enable versioning (required for object lock)
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure object lock
resource "aws_s3_bucket_object_lock_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 90
    }
  }
}

# Add bucket public access block (security best practice)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}