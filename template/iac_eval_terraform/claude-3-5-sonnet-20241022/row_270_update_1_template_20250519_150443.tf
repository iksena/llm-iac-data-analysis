provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with ownership controls
resource "aws_s3_bucket" "my_bucket" {
  bucket = "mybucket"
}

# Configure ownership controls
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure bucket ACL (depends on ownership controls)
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}