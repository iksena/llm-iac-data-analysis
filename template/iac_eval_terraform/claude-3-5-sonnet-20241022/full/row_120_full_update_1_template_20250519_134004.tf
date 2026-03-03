I'll help you create a Terraform configuration for managing AWS S3 resources with proper bucket ownership controls and ACL settings. Here's what the configuration will do:

1. Create an S3 bucket with a specific name
2. Configure bucket ownership controls to ensure proper object ownership
3. Set up private ACL settings for the bucket
4. Include necessary provider configuration
5. Add variables with default values for customization

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-terraform-managed-bucket-2024"
}

# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  # Enable versioning
  versioning {
    enabled = true
  }

  # Prevent accidental deletion of this bucket
  lifecycle {
    prevent_destroy = true
  }
}

# S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 Bucket ACL
resource "aws_s3_bucket_acl" "main" {
  depends_on = [aws_s3_bucket_ownership_controls.main]

  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Output the bucket name and ARN
output "bucket_name" {
  value = aws_s3_bucket.main.id
}

output "bucket_arn" {
  value = aws_s3_bucket.main.arn
}
</iac_template>

This Terraform configuration creates a secure S3 bucket with the following features:

1. Creates an S3 bucket with a customizable name (default provided)
2. Sets bucket ownership controls to "BucketOwnerPreferred"
3. Configures private ACL settings
4. Blocks all public access to the bucket
5. Enables server-side encryption with AES256
6. Enables versioning
7. Prevents accidental deletion of the bucket
8. Outputs the bucket name and ARN for reference

The configuration includes proper dependency management using depends_on where needed, and all resources reference each other appropriately. The bucket is created with security best practices in mind, including encryption and public access blocking.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

You can customize the bucket name by either:
- Changing the default value in the variable declaration
- Setting it when running Terraform: `terraform apply -var="bucket_name=your-bucket-name"`