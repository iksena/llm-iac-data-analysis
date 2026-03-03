I'll help you create a Terraform configuration for AWS S3 storage with lifecycle policies for long-term data storage and backup. This configuration will:

1. Create an S3 bucket with versioning enabled
2. Implement lifecycle rules to transition objects to cheaper storage tiers
3. Enable server-side encryption
4. Add necessary bucket policies for security
5. Create an IAM role for bucket access

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "long-term-storage-backup-bucket"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# S3 Bucket
resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = var.environment
    Purpose     = "Long-term storage and backup"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.storage_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.storage_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.storage_bucket.id

  rule {
    id     = "transition_to_ia_and_glacier"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM Role for bucket access
resource "aws_iam_role" "s3_backup_role" {
  name = "s3-backup-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for the role
resource "aws_iam_role_policy" "s3_backup_policy" {
  name = "s3-backup-access-policy"
  role = aws_iam_role.s3_backup_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.storage_bucket.arn,
          "${aws_s3_bucket.storage_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Outputs
output "bucket_name" {
  value       = aws_s3_bucket.storage_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.storage_bucket.arn
  description = "The ARN of the bucket"
}

output "iam_role_arn" {
  value       = aws_iam_role.s3_backup_role.arn
  description = "The ARN of the IAM role"
}
</iac_template>

This Terraform configuration creates:

1. An S3 bucket with versioning enabled for backup purposes
2. Server-side encryption using AES256
3. Lifecycle rules that:
   - Transition objects to Standard-IA after 90 days
   - Transition objects to Glacier after 180 days
   - Move non-current versions to Glacier after 90 days
4. Complete blocking of public access to the bucket
5. An IAM role with appropriate permissions to access the bucket
6. Useful outputs for bucket name, ARN, and IAM role ARN

The configuration includes all necessary security features and follows AWS best practices for long-term storage and backup. You can customize the bucket name and environment through variables, and the lifecycle rules can be adjusted based on your specific requirements.

To deploy this, you would need to:
1. Have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

Remember to adjust the bucket name variable as S3 bucket names must be globally unique across all AWS accounts.