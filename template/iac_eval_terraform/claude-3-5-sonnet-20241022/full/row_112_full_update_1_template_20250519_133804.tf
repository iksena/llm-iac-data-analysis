I'll help you create a Terraform configuration for an S3 bucket with object lock enabled and compliance mode retention settings. This configuration will:

1. Create an S3 bucket with object lock enabled (must be enabled at bucket creation)
2. Configure object lock with compliance mode and 30-day retention period
3. Set up basic bucket settings and versioning (required for object lock)

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with object lock enabled
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"

  # Object lock must be enabled at bucket creation
  object_lock_enabled = true

  # Force destroy must be false when using object lock
  force_destroy = false
}

# Enable versioning (required for object lock)
resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure object lock
resource "aws_s3_bucket_object_lock_configuration" "example_bucket_lock" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 30
    }
  }
}

# Configure public access block for security
resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This Terraform configuration creates an S3 bucket with the following specifications:

1. Creates a bucket named "example-bucket" with object lock enabled
2. Enables versioning (required for object lock functionality)
3. Configures object lock with:
   - Compliance mode (cannot be overridden or disabled)
   - 30-day retention period for all objects
4. Blocks all public access to the bucket for security

Important notes:
- Object lock must be enabled at bucket creation and cannot be modified later
- Versioning is automatically enabled and cannot be disabled when object lock is enabled
- The bucket name must be globally unique across all AWS accounts
- The compliance mode cannot be disabled or shortened once set
- Force destroy is set to false as it's not compatible with object lock
- Public access is blocked for security best practices

This configuration provides a secure S3 bucket with enforced retention periods that cannot be overridden, suitable for compliance and regulatory requirements.