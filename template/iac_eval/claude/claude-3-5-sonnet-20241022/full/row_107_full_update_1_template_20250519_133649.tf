I'll help you create a Terraform configuration that sets up an S3 bucket with versioning enabled and specified bucket ownership. Here's what the configuration will do:

1. Create an S3 bucket named "sample"
2. Enable versioning on the bucket
3. Specify the expected bucket owner
4. Configure the AWS provider with a specific region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "sample_bucket" {
  bucket = "sample"

  # Enable force destroy for easier cleanup (optional)
  force_destroy = true

  # Tags for better resource management
  tags = {
    Name        = "Sample Bucket"
    Environment = "Development"
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "sample_bucket_versioning" {
  bucket = aws_s3_bucket.sample_bucket.id
  
  expected_bucket_owner = "123456789012"
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Add bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "sample_bucket_ownership" {
  bucket = aws_s3_bucket.sample_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Add bucket public access block
resource "aws_s3_bucket_public_access_block" "sample_bucket_public_access" {
  bucket = aws_s3_bucket.sample_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-east-1 region
2. Creates an S3 bucket named "sample"
3. Enables versioning on the bucket with the specified expected_bucket_owner
4. Adds bucket ownership controls to ensure consistent ownership
5. Implements best practices by blocking public access to the bucket

The configuration includes additional security measures like blocking public access and setting proper ownership controls. The force_destroy option is set to true to make cleanup easier in development environments. All resources are properly tagged for better resource management.

Note: Make sure to replace "123456789012" with your actual AWS account ID when deploying this configuration.