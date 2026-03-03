I'll help you create a Terraform configuration for an S3 bucket where the bucket owner pays for all storage and data transfer fees, regardless of who uploads the objects. This is useful when you want to maintain control over costs and prevent other AWS accounts from generating charges to your bucket.

The configuration will:
1. Create an S3 bucket with Requester Pays disabled (meaning the bucket owner pays)
2. Set appropriate bucket ownership controls
3. Configure basic security settings
4. Set up versioning for data protection

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket with owner pays configuration
resource "aws_s3_bucket" "owner_pays_bucket" {
  bucket = "my-owner-pays-bucket-${random_string.suffix.result}"
}

# Create random suffix for unique bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.owner_pays_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.owner_pays_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure bucket public access block
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.owner_pays_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.owner_pays_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
</iac_template>

This configuration creates:
1. A unique S3 bucket with a random suffix to ensure uniqueness
2. Bucket ownership controls set to "BucketOwnerPreferred" ensuring the bucket owner owns all objects
3. Versioning enabled for data protection
4. Public access blocked for security
5. Server-side encryption enabled using AES256

The bucket owner will pay for:
- Storage costs
- Data transfer costs
- Request costs
- Other associated S3 fees

The configuration includes security best practices and ensures the bucket owner maintains control over all costs associated with the bucket.