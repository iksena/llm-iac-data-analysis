provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "sample_bucket" {
  bucket = "sample"

  # Enable force destroy for easier cleanup (optional)
  force_destroy = true

  # Tags for better resource management
  tags = {
    Name        = "Sample Bucket"
    Environment = "Development"
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "sample_bucket_versioning" {
  bucket = aws_s3_bucket.sample_bucket.id
  
  expected_bucket_owner = "123456789012"
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Add bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "sample_bucket_ownership" {
  bucket = aws_s3_bucket.sample_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Add bucket public access block
resource "aws_s3_bucket_public_access_block" "sample_bucket_public_access" {
  bucket = aws_s3_bucket.sample_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}