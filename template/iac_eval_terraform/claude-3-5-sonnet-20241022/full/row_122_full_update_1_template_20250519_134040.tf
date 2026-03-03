I'll help you create a Terraform configuration for an AWS S3 bucket object. This configuration will:
1. Set up the AWS provider
2. Create an S3 bucket with the specified name
3. Create an S3 bucket object with the specified attributes
4. Include necessary variables with default values

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "your_bucket_name"
}

# Add bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Add server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create S3 bucket object
resource "aws_s3_object" "example_object" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "new_object_key"
  source = "path/to/file"

  # Optional: Detect content type
  content_type = "application/octet-stream"

  # Enable server-side encryption
  server_side_encryption = "AES256"

  # Add tags
  tags = {
    Name        = "Example Object"
    Environment = "Production"
  }
}
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-west-2 region
2. Creates an S3 bucket named "your_bucket_name"
3. Enables versioning on the bucket
4. Configures server-side encryption
5. Blocks public access to the bucket
6. Creates an S3 bucket object with:
   - The specified key ("new_object_key")
   - The specified source file path ("path/to/file")
   - Server-side encryption enabled
   - Content type specified
   - Tags for better resource management

Note: Make sure to:
1. Replace "your_bucket_name" with a globally unique bucket name
2. Ensure "path/to/file" points to an actual file on your local system
3. Have appropriate AWS credentials configured
4. Consider that S3 bucket names must be globally unique across all AWS accounts

The configuration includes security best practices such as:
- Enabled versioning
- Server-side encryption
- Blocked public access
- Tagged resources for better management