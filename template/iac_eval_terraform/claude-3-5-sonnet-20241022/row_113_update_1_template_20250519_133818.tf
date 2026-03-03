provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "pike_bucket" {
  bucket = "pike-680235478471"
}

# Configure request payment
resource "aws_s3_bucket_request_payment_configuration" "pike_bucket_payment" {
  bucket = aws_s3_bucket.pike_bucket.id
  payer  = "Requester"
}

# Configure bucket ownership
resource "aws_s3_bucket_ownership_controls" "pike_bucket_ownership" {
  bucket = aws_s3_bucket.pike_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure bucket versioning
resource "aws_s3_bucket_versioning" "pike_bucket_versioning" {
  bucket = aws_s3_bucket.pike_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure bucket public access block
resource "aws_s3_bucket_public_access_block" "pike_bucket_public_access_block" {
  bucket = aws_s3_bucket.pike_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}