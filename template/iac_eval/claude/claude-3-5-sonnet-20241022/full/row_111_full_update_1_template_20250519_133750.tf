I'll help you create a Terraform configuration for an S3 bucket with object lock enabled and governance mode retention settings. Here's what the configuration will do:

1. Creates an S3 bucket with a specific name 'example-bucket'
2. Enables object lock functionality on the bucket
3. Configures object lock with governance mode
4. Sets a default retention period of 90 days
5. Includes versioning (required for object lock)

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with object lock enabled
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"

  # Object Lock must be enabled at bucket creation
  object_lock_enabled = true

  # Force destroy must be set to true if you want to delete the bucket with locked objects
  force_destroy = true
}

# Enable versioning (required for object lock)
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure object lock
resource "aws_s3_bucket_object_lock_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 90
    }
  }
}

# Add bucket public access block (security best practice)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This configuration creates an S3 bucket with object lock enabled and configures the following:

1. The AWS provider is set to use the us-east-1 region
2. Creates an S3 bucket named 'example-bucket' with object lock enabled
3. Enables versioning on the bucket (required for object lock)
4. Configures object lock with:
   - Governance mode
   - 90-day retention period
5. Blocks all public access to the bucket as a security best practice

Important notes:
- Object lock must be enabled when the bucket is created and cannot be disabled later
- Versioning is automatically enabled and cannot be disabled when object lock is enabled
- The force_destroy option is set to true to allow bucket deletion even with locked objects (useful for testing)
- Public access is blocked by default using aws_s3_bucket_public_access_block

This configuration provides a secure S3 bucket with governance mode retention that prevents object deletion or modification for 90 days, while still allowing authorized users to override the retention settings if necessary.