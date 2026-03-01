I'll help you create a Terraform configuration for setting up two AWS S3 buckets with the specified access control and logging features. Here's what the configuration will do:

1. Create two S3 buckets:
   - A main bucket for storing data (private access)
   - A logging bucket to store access logs (log delivery write access)
2. Configure appropriate ACLs for both buckets
3. Set up logging from the main bucket to the logging bucket
4. Include necessary IAM policies and dependencies

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

# Main S3 Bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket = "main-data-bucket-${random_string.random.result}"

  tags = {
    Name        = "Main Data Bucket"
    Environment = "Production"
  }
}

# Logging S3 Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "access-logs-bucket-${random_string.random.result}"

  tags = {
    Name        = "Access Logs Bucket"
    Environment = "Production"
  }
}

# ACL for main bucket
resource "aws_s3_bucket_acl" "main_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.main_bucket_ownership]
  bucket     = aws_s3_bucket.main_bucket.id
  acl        = "private"
}

# ACL for log bucket
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_ownership]
  bucket     = aws_s3_bucket.log_bucket.id
  acl        = "log-delivery-write"
}

# Bucket ownership controls for main bucket
resource "aws_s3_bucket_ownership_controls" "main_bucket_ownership" {
  bucket = aws_s3_bucket.main_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucket ownership controls for log bucket
resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Enable logging for main bucket
resource "aws_s3_bucket_logging" "main_bucket_logging" {
  bucket = aws_s3_bucket.main_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Block public access for main bucket
resource "aws_s3_bucket_public_access_block" "main_bucket_public_access_block" {
  bucket = aws_s3_bucket.main_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for log bucket
resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for main bucket
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning for log bucket
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
</iac_template>

This Terraform configuration creates:

1. Two S3 buckets with unique names using a random string suffix
2. Appropriate ACL settings:
   - Main bucket: private access
   - Log bucket: log-delivery-write access
3. Logging configuration from the main bucket to the log bucket
4. Public access blocks for both buckets
5. Versioning enabled for both buckets
6. Proper bucket ownership controls

The configuration includes all necessary dependencies and ensures secure access controls. The random string resource helps avoid naming conflicts when creating buckets. Both buckets are configured with versioning enabled for better data protection, and public access is blocked for security purposes.