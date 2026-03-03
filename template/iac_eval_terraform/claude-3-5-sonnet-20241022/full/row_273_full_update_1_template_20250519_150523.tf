I'll help you create a Terraform configuration that sets up an S3 bucket with an inventory configuration. The inventory will generate daily reports about the objects in your bucket.

This configuration will:
1. Create an S3 bucket named "mybucket"
2. Create another S3 bucket to store the inventory reports
3. Create an IAM role and policy for S3 inventory
4. Configure daily inventory reporting for all objects
5. Set up the inventory to report basic metadata fields

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create main S3 bucket
resource "aws_s3_bucket" "main" {
  bucket = "mybucket"
}

# Create bucket for inventory reports
resource "aws_s3_bucket" "inventory" {
  bucket = "mybucket-inventory"
}

# Create bucket policy for inventory bucket
resource "aws_s3_bucket_policy" "inventory" {
  bucket = aws_s3_bucket.inventory.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3BucketInventory"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = [
          "${aws_s3_bucket.inventory.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.main.arn
          }
        }
      }
    ]
  })
}

# Enable versioning on inventory bucket
resource "aws_s3_bucket_versioning" "inventory" {
  bucket = aws_s3_bucket.inventory.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure inventory for main bucket
resource "aws_s3_bucket_inventory" "main" {
  bucket = aws_s3_bucket.main.id
  name   = "daily-inventory"

  included_object_versions = "All"

  schedule {
    frequency = "Daily"
  }

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = aws_s3_bucket.inventory.arn
    }
  }

  optional_fields = [
    "Size",
    "LastModifiedDate",
    "StorageClass",
    "ETag",
    "IsMultipartUploaded",
    "ReplicationStatus"
  ]
}

# Block public access for main bucket
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for inventory bucket
resource "aws_s3_bucket_public_access_block" "inventory" {
  bucket = aws_s3_bucket.inventory.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This configuration creates:
1. A main S3 bucket named "mybucket"
2. An inventory bucket named "mybucket-inventory"
3. A bucket policy that allows S3 to write inventory reports
4. Daily inventory configuration that includes various object metadata
5. Security configurations to block public access to both buckets

The inventory reports will be generated daily and stored in CSV format in the inventory bucket. The reports will include metadata such as object size, last modified date, storage class, ETag, multipart upload status, and replication status.

Note: Make sure the bucket names are globally unique across all AWS accounts. You might need to modify the bucket names if they're already taken.