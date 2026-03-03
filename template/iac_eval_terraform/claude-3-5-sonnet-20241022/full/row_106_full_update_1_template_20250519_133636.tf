I'll help you create a Terraform configuration for a secure S3 bucket with the specified requirements. This configuration will:

1. Create an S3 bucket named 'test-bucket'
2. Enable versioning to prevent accidental deletion of objects
3. Implement private ACLs
4. Enable AES256 server-side encryption
5. Block all public access
6. Add deletion protection through a lifecycle rule

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "test-bucket"

  # Prevent accidental deletion of this bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Set private ACL
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
</iac_template>

This configuration creates a highly secure S3 bucket with the following features:

1. The bucket name is set to "test-bucket"
2. The `prevent_destroy` lifecycle rule ensures the bucket cannot be accidentally destroyed through Terraform
3. Versioning is enabled to protect against accidental deletions and maintain object history
4. Server-side encryption is enabled using AES256
5. All public access is blocked using the public access block settings
6. Object ownership is set to "BucketOwnerEnforced" which enforces private ACLs
7. The AWS provider is configured to use the us-east-1 region

Note that you'll need appropriate AWS credentials configured to apply this template. Also, ensure that the bucket name "test-bucket" is globally unique across all AWS accounts, as S3 bucket names must be globally unique.