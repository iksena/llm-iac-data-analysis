Below is a description of the Terraform program that sets up an AWS S3 bucket and a DynamoDB table for Terraform state management. The S3 bucket is configured with preventive measures against accidental deletion (using Terraform’s lifecycle with prevent_destroy), versioning enabled, server‐side encryption using AES256 (using a separate encryption configuration resource), and public access restrictions (through an S3 public access block). Additionally, a DynamoDB table is created with a hash key named "LockID" and uses the PAY_PER_REQUEST billing mode for state locking. All necessary providers, IAM permissions, and variable definitions with default values are included in the configuration.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "terraform-state-management-bucket-123456"  # note: bucket names must be globally unique
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "TerraformStateLockingTable"
}

# Create the S3 bucket for Terraform state management
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "TerraformStateBucket"
  }
}

# Configure server-side encryption on the S3 bucket using AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Restrict public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLockingTable"
  }
}
</iac_template>