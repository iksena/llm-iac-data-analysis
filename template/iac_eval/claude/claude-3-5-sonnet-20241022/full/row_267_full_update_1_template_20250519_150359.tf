I'll help you create a simple Terraform configuration to deploy an AWS S3 bucket. This configuration will:
1. Set up the AWS provider
2. Create a basic S3 bucket with a unique name
3. Enable versioning on the bucket
4. Add standard tags for resource management

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-example-terraform-bucket-2024"

  tags = {
    Name        = "Example Bucket"
    Environment = "Dev"
    Managed_by  = "Terraform"
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This Terraform configuration creates:
1. An S3 bucket named "my-example-terraform-bucket-2024"
2. Enables versioning on the bucket for better data protection
3. Configures server-side encryption using AES256
4. Blocks all public access to the bucket for security
5. Adds relevant tags for resource management

The configuration follows AWS best practices by:
- Using a unique bucket name
- Enabling versioning for data protection
- Implementing encryption at rest
- Blocking public access by default
- Including resource tags for better management

Note: You might need to change the bucket name as S3 bucket names must be globally unique across all AWS accounts.