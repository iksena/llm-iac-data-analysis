provider "aws" {
  region = "us-east-1"
}

# Random string to ensure unique bucket names
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Main S3 Bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket = "main-data-bucket-${random_string.random.result}"

  tags = {
    Name        = "Main Data Bucket"
    Environment = "Production"
  }
}

# Logging S3 Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "access-logs-bucket-${random_string.random.result}"

  tags = {
    Name        = "Access Logs Bucket"
    Environment = "Production"
  }
}

# ACL for main bucket
resource "aws_s3_bucket_acl" "main_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.main_bucket_ownership]
  bucket     = aws_s3_bucket.main_bucket.id
  acl        = "private"
}

# ACL for log bucket
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_ownership]
  bucket     = aws_s3_bucket.log_bucket.id
  acl        = "log-delivery-write"
}

# Bucket ownership controls for main bucket
resource "aws_s3_bucket_ownership_controls" "main_bucket_ownership" {
  bucket = aws_s3_bucket.main_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucket ownership controls for log bucket
resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Enable logging for main bucket
resource "aws_s3_bucket_logging" "main_bucket_logging" {
  bucket = aws_s3_bucket.main_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Block public access for main bucket
resource "aws_s3_bucket_public_access_block" "main_bucket_public_access_block" {
  bucket = aws_s3_bucket.main_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for log bucket
resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for main bucket
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning for log bucket
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}