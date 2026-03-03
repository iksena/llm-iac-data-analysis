provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "mybucket"
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure bucket ownership
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Upload file to S3 bucket
resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "uploaded-file"  # The name the file will have in S3
  source = "path/to/file"   # Local path to the file you want to upload
}