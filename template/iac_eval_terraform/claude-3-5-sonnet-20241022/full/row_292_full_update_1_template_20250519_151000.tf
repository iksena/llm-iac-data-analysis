I'll help you create a Terraform configuration that sets up two S3 buckets with logging enabled from the first bucket to the second bucket. The configuration will:

1. Create a primary S3 bucket for general use
2. Create a secondary S3 bucket dedicated to storing logs
3. Configure logging on the primary bucket to store logs in the secondary bucket with a "log/" prefix
4. Set up necessary bucket policies and ACLs for logging

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create the logging bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-logging-bucket-${random_string.random_suffix.result}"
}

# Create the primary bucket
resource "aws_s3_bucket" "primary_bucket" {
  bucket = "my-primary-bucket-${random_string.random_suffix.result}"
}

# Generate random suffix for unique bucket names
resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enable versioning for log bucket
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning for primary bucket
resource "aws_s3_bucket_versioning" "primary_bucket_versioning" {
  bucket = aws_s3_bucket.primary_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure ACL for log bucket to allow logging
resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_ownership]
  bucket     = aws_s3_bucket.log_bucket.id
  acl        = "log-delivery-write"
}

# Configure logging from primary bucket to log bucket
resource "aws_s3_bucket_logging" "primary_bucket_logging" {
  bucket = aws_s3_bucket.primary_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Add bucket policies
resource "aws_s3_bucket_public_access_block" "log_bucket_access" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "primary_bucket_access" {
  bucket = aws_s3_bucket.primary_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This configuration creates:
1. A random string generator to ensure unique bucket names
2. Two S3 buckets (primary and logging)
3. Versioning enabled on both buckets for better data protection
4. Proper ACL configuration on the logging bucket to allow log delivery
5. Logging configuration on the primary bucket that sends logs to the logging bucket with "log/" prefix
6. Public access blocks on both buckets for security

The configuration uses the AWS provider in the us-east-1 region and includes all necessary resources and configurations to make the logging work properly. The bucket names will be unique due to the random suffix, preventing naming conflicts when deploying multiple times or across different accounts.