I'll help you create a Terraform configuration that sets up an encrypted S3 bucket using a KMS key in AWS. Here's what the configuration will do:

1. Create an AWS KMS key with a 7-day deletion window and a specific description
2. Create an S3 bucket with a unique name
3. Configure server-side encryption for the S3 bucket using the KMS key
4. Set up necessary IAM policies for the KMS key

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create KMS key
resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

# Create KMS key alias
resource "aws_kms_alias" "s3_encryption_key_alias" {
  name          = "alias/s3-encryption-key"
  target_key_id = aws_kms_key.s3_encryption_key.key_id
}

# Create S3 bucket
resource "aws_s3_bucket" "encrypted_bucket" {
  bucket = "my-encrypted-bucket-${random_string.bucket_suffix.result}"
}

# Create random string for unique bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.encrypted_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.encrypted_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.encrypted_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This Terraform configuration creates:

1. An AWS KMS key with:
   - A 7-day deletion window
   - Key rotation enabled
   - A basic IAM policy allowing key usage
   - An alias for easy reference

2. An S3 bucket with:
   - A unique name using a random suffix
   - Versioning enabled
   - Server-side encryption using the KMS key
   - Public access blocked

3. The encryption configuration:
   - Uses the AWS KMS encryption algorithm
   - References the KMS key's ARN
   - Applies encryption by default to all objects in the bucket

The configuration includes all necessary security best practices such as:
- Blocking public access to the S3 bucket
- Enabling versioning
- Using a custom KMS key instead of the default AWS managed key
- Adding a random suffix to the bucket name to ensure uniqueness

To deploy this configuration, you would need appropriate AWS credentials and permissions. The bucket name will be automatically generated with a random suffix to ensure uniqueness across all AWS accounts.