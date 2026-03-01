terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Random string to make bucket name unique
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Create S3 bucket
resource "aws_s3_bucket" "pdf_bucket" {
  bucket = "pdf-storage-${random_string.random.result}"

  tags = {
    Name        = "PDF Storage"
    Environment = "Production"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "pdf_bucket_versioning" {
  bucket = aws_s3_bucket.pdf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure bucket access
resource "aws_s3_bucket_public_access_block" "pdf_bucket_access" {
  bucket = aws_s3_bucket.pdf_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "pdf_bucket_encryption" {
  bucket = aws_s3_bucket.pdf_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Upload PDF file to S3
resource "aws_s3_object" "pdf_upload" {
  bucket = aws_s3_bucket.pdf_bucket.id
  key    = "test.pdf"
  source = "assets/test.pdf"

  tags = {
    Name = "Test PDF"
  }
}