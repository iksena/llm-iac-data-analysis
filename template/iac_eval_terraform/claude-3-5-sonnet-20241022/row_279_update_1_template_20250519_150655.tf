provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with object lock enabled
resource "aws_s3_bucket" "locked_bucket" {
  bucket = "mybucket"

  # Object Lock configuration must be enabled during bucket creation
  object_lock_enabled = true

  # Force destroy must be set to true if you want to delete the bucket with locked objects
  force_destroy = true
}

# Configure object lock settings for the bucket
resource "aws_s3_bucket_object_lock_configuration" "bucket_lock" {
  bucket = aws_s3_bucket.locked_bucket.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 730
    }
  }
}

# Enable versioning (required for object lock)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.locked_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}