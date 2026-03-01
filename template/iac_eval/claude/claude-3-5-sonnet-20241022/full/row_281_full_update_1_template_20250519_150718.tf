I'll help you create a Terraform configuration that sets up an S3 bucket with KMS encryption. This configuration will:

1. Create a KMS key with a key policy
2. Create an S3 bucket
3. Enable server-side encryption on the S3 bucket using the created KMS key
4. Apply necessary IAM policies and aliases

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create KMS key
resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation    = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

# Create KMS alias
resource "aws_kms_alias" "s3_encryption_key_alias" {
  name          = "alias/s3-encryption-key"
  target_key_id = aws_kms_key.s3_encryption_key.key_id
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create S3 bucket
resource "aws_s3_bucket" "encrypted_bucket" {
  bucket = "my-encrypted-bucket-${data.aws_caller_identity.current.account_id}"
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.encrypted_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.encrypted_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.encrypted_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.encrypted_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.encrypted_bucket.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "aws:kms"
          }
        }
      }
    ]
  })
}
</iac_template>

This Terraform configuration creates:

1. A KMS key with a basic policy allowing the account root to manage it
2. A KMS alias for easier key identification
3. An S3 bucket with a unique name based on the AWS account ID
4. Enables versioning on the bucket
5. Configures server-side encryption using the created KMS key
6. Blocks all public access to the bucket
7. Applies a bucket policy that denies unencrypted object uploads

The configuration includes several security best practices:
- Bucket versioning is enabled
- Public access is completely blocked
- Key rotation is enabled for the KMS key
- A bucket policy enforces encryption
- The bucket name is made unique using the AWS account ID

To deploy this configuration, you would need appropriate AWS credentials and permissions. The bucket name will be automatically generated using your AWS account ID to ensure uniqueness.