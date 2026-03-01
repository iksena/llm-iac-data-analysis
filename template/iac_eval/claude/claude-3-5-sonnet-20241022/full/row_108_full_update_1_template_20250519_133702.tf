I'll help you create a Terraform configuration to set up a secure S3 bucket and DynamoDB table for managing Terraform state. This configuration will include:

1. An S3 bucket with:
   - Versioning enabled
   - Server-side encryption using AES256
   - Public access blocking
   - Deletion protection
   - Appropriate bucket policy

2. A DynamoDB table for state locking with:
   - LockID as the partition key
   - PAY_PER_REQUEST billing mode
   - Basic encryption settings

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "terraform-state"
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project}-${var.environment}-state-store"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.project}-${var.environment}-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "${var.project}-${var.environment}-state-lock"
    Environment = var.environment
  }
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnforcedTLS"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport": "false"
          }
        }
      }
    ]
  })
}
</iac_template>

This Terraform configuration creates a secure environment for storing Terraform state files. Here's what each component does:

1. The AWS provider is configured for the us-east-1 region
2. Variables are defined for environment and project names with default values
3. S3 bucket configuration includes:
   - Versioning enabled for state file version control
   - Server-side encryption using AES256
   - Complete public access blocking
   - Lifecycle rule to prevent accidental deletion
   - Bucket policy requiring TLS for all operations

4. DynamoDB table configuration includes:
   - PAY_PER_REQUEST billing mode for cost optimization
   - LockID as the partition key for state locking
   - Server-side encryption enabled
   - Point-in-time recovery enabled for backup purposes
   - Appropriate tags for resource management

The configuration is complete and deployable, with all necessary security features implemented. To use this state store in other Terraform configurations, you would reference it in the backend configuration of those configurations.