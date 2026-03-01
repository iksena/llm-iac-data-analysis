I'll help you create a Terraform configuration that sets up two S3 buckets - one main bucket for your data and another bucket to store the inventory reports. The inventory will be configured to generate weekly CSV reports of all current object versions.

Description:
This Terraform configuration will:
1. Create a main S3 bucket for storing data
2. Create another S3 bucket for storing inventory reports
3. Configure S3 inventory to generate weekly CSV reports
4. Set up necessary IAM roles and policies for inventory reporting
5. Enable versioning on both buckets for data protection

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create main S3 bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket = "main-data-bucket-${random_string.random_suffix.result}"
}

resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create inventory destination bucket
resource "aws_s3_bucket" "inventory_bucket" {
  bucket = "inventory-bucket-${random_string.random_suffix.result}"
}

resource "aws_s3_bucket_versioning" "inventory_bucket_versioning" {
  bucket = aws_s3_bucket.inventory_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Generate random suffix for bucket names
resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create IAM role for inventory
resource "aws_iam_role" "inventory_role" {
  name = "s3-inventory-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for inventory
resource "aws_iam_role_policy" "inventory_policy" {
  name = "s3-inventory-policy"
  role = aws_iam_role.inventory_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.inventory_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Create bucket policy for inventory bucket
resource "aws_s3_bucket_policy" "inventory_bucket_policy" {
  bucket = aws_s3_bucket.inventory_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "InventoryPolicy"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.inventory_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.main_bucket.arn
          }
        }
      }
    ]
  })
}

# Configure S3 inventory
resource "aws_s3_bucket_inventory" "inventory_config" {
  bucket = aws_s3_bucket.main_bucket.id
  name   = "weekly-inventory"

  schedule {
    frequency = "Weekly"
  }

  included_object_versions = "Current"

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = aws_s3_bucket.inventory_bucket.arn
    }
  }

  optional_fields = [
    "Size",
    "LastModifiedDate",
    "StorageClass",
    "ETag",
    "IsMultipartUploaded",
    "ReplicationStatus",
    "EncryptionStatus"
  ]
}
</iac_template>

This configuration creates:
1. Two S3 buckets with unique names (using a random suffix)
2. Enables versioning on both buckets
3. Creates an IAM role and policy for S3 inventory
4. Sets up a bucket policy on the inventory bucket to allow the main bucket to write inventory reports
5. Configures weekly inventory reporting in CSV format with detailed object information

The inventory report will include current object versions and additional metadata such as size, last modified date, storage class, and encryption status. The reports will be generated weekly and stored in the inventory bucket.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Remember that S3 bucket names must be globally unique, which is why we're using a random suffix in the bucket names.