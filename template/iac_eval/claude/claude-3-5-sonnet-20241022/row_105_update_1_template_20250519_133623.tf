provider "aws" {
  region = "us-west-2"
}

# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket        = "my-bucket-unique-name-123"
  force_destroy = true
}

# Create S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Create S3 Bucket Metric Configuration
resource "aws_s3_bucket_metric" "my_bucket_metric" {
  bucket = aws_s3_bucket.my_bucket.id
  name   = "my_bucket_metric"

  filter {
    prefix = ""
  }
}

# Create S3 Bucket Object
resource "aws_s3_bucket_object" "my_object" {
  bucket  = aws_s3_bucket.my_bucket.id
  key     = "example/my-file.txt"
  content = "This is the content of my S3 bucket object"

  content_type = "text/plain"

  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership
  ]
}