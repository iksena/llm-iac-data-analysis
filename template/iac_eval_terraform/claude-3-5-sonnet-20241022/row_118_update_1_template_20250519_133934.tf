provider "aws" {
  region = "us-west-2"
}

# Random string for unique bucket naming
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket with versioning and object lock
resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "mybucket-${random_string.bucket_suffix.result}"

  # Enable object lock during bucket creation
  object_lock_enabled = true

  # Prevent accidental deletion of bucket
  force_destroy = false
}

# Enable versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.compliance_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure object lock
resource "aws_s3_bucket_object_lock_configuration" "bucket_object_lock" {
  bucket = aws_s3_bucket.compliance_bucket.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}

# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.compliance_bucket.id
}

# Output the bucket ARN
output "bucket_arn" {
  value = aws_s3_bucket.compliance_bucket.arn
}