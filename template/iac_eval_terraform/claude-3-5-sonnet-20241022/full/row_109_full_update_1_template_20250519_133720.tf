I'll help you create a Terraform configuration for an S3 bucket with the specified requirements. Here's what the configuration will include:

1. AWS provider configuration
2. S3 bucket with:
   - Versioning enabled
   - Private ACL
   - Deletion protection
   - Lifecycle rules for:
     - Objects with 'tmp/' prefix
     - Transition rules for old versions
     - Deletion rules for noncurrent versions

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates an S3 bucket with the following features:

1. Creates a bucket named 'wellcomecollection-platform-infra'
2. Enables versioning on the bucket
3. Sets the bucket ACL to private
4. Configures lifecycle rules:
   - Deletes objects with 'tmp/' prefix after 30 days
   - Transitions noncurrent versions to STANDARD_IA after 30 days
   - Deletes noncurrent versions after 90 days
5. Implements preventive destruction measures:
   - Sets force_destroy to false
   - Blocks all public access
6. Enables server-side encryption using AES256

The configuration includes all necessary security measures and meets the specified requirements for object lifecycle management and version control.