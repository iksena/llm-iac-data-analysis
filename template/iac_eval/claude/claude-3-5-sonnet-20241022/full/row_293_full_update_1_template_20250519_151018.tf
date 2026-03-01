I'll help you create a Terraform configuration that sets up two S3 buckets - one for the main content and another for storing server access logs. The configuration will include:

1. A logging bucket to store the server access logs
2. A main bucket with logging enabled, pointing to the logging bucket
3. Necessary bucket policies and configurations for secure logging
4. Required IAM policies to allow logging between buckets

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Random string to ensure unique bucket names
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# S3 bucket for storing logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = "access-logs-${random_string.random.result}"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

# S3 bucket versioning for log bucket
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket ownership controls for log bucket
resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 bucket ACL for log bucket
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_ownership]
  bucket     = aws_s3_bucket.log_bucket.id
  acl        = "log-delivery-write"
}

# Main S3 bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket = "main-bucket-${random_string.random.result}"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning for main bucket
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket ownership controls for main bucket
resource "aws_s3_bucket_ownership_controls" "main_bucket_ownership" {
  bucket = aws_s3_bucket.main_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 bucket ACL for main bucket
resource "aws_s3_bucket_acl" "main_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.main_bucket_ownership]
  bucket     = aws_s3_bucket.main_bucket.id
  acl        = "private"
}

# Enable logging for main bucket
resource "aws_s3_bucket_logging" "main_bucket_logging" {
  bucket = aws_s3_bucket.main_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Server-side encryption for log bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Server-side encryption for main bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "main_bucket_encryption" {
  bucket = aws_s3_bucket.main_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access for log bucket
resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for main bucket
resource "aws_s3_bucket_public_access_block" "main_bucket_public_access_block" {
  bucket = aws_s3_bucket.main_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This Terraform configuration creates:

1. A logging bucket with:
   - Versioning enabled
   - Server-side encryption
   - Appropriate ACL for log delivery
   - Public access blocked
   - Random suffix in the name to ensure uniqueness

2. A main bucket with:
   - Logging enabled, pointing to the logging bucket
   - Versioning enabled
   - Server-side encryption
   - Private ACL
   - Public access blocked
   - Random suffix in the name to ensure uniqueness

The configuration includes all necessary security controls and best practices:
- Both buckets have versioning enabled
- Both buckets have server-side encryption enabled
- Both buckets block all public access
- The log bucket has the required ACL for log delivery
- Both buckets have prevent_destroy lifecycle rule to prevent accidental deletion
- Proper bucket ownership controls are configured
- Random string generation ensures unique bucket names

To deploy this configuration, you would need to:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`