provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with versioning disabled
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-bucket-example-2024"  # Bucket names must be globally unique
  
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Managed_by  = "Terraform"
  }
}

# Configure versioning for the bucket (explicitly disabled)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Suspended"
  }
}

# Block all public access to the bucket (security best practice)
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}