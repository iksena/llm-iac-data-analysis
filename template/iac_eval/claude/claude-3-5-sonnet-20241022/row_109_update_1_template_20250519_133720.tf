provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket
resource "aws_s3_bucket" "platform_infra" {
  bucket = "wellcomecollection-platform-infra"

  # Prevent accidental deletion of this bucket
  force_destroy = false
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.platform_infra.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Set bucket ACL to private
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.platform_infra.id
  acl    = "private"
}

# Enable bucket lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.platform_infra.id

  # Rule for tmp/ prefix objects
  rule {
    id     = "tmp_cleanup"
    status = "Enabled"

    filter {
      prefix = "tmp/"
    }

    expiration {
      days = 30
    }
  }

  # Rule for transitioning old versions to STANDARD_IA and cleanup
  rule {
    id     = "version_management"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# Enable bucket public access blocking
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.platform_infra.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.platform_infra.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}