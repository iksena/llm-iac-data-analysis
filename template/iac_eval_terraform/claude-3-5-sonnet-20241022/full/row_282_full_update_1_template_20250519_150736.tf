I'll help you create a Terraform configuration that sets up an S3 bucket with CORS (Cross-Origin Resource Sharing) rules. This configuration will:

1. Create an S3 bucket with basic settings
2. Configure CORS rules for the bucket allowing:
   - GET and POST methods
   - Origins from example.com
   - All headers
   - Max age of 3000 seconds

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "cors_demo_bucket" {
  bucket = "my-cors-demo-bucket-${random_id.suffix.hex}"
}

# Create random suffix for bucket name
resource "random_id" "suffix" {
  byte_length = 4
}

# Configure bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.cors_demo_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure CORS rules
resource "aws_s3_bucket_cors_configuration" "cors_configuration" {
  bucket = aws_s3_bucket.cors_demo_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://example.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  # Additional CORS rule example
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

# Configure bucket public access block
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.cors_demo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider in the us-east-1 region
2. Creates an S3 bucket with a random suffix to ensure unique naming
3. Enables versioning on the bucket
4. Configures two CORS rules:
   - First rule allows GET and POST requests from example.com
   - Second rule allows GET requests from any origin
5. Sets up a public access block to ensure the bucket remains private

The CORS configuration includes all required attributes:
- allowed_headers: Specifies which headers are allowed
- allowed_methods: Specifies which HTTP methods are allowed
- allowed_origins: Specifies which origins are allowed to make cross-origin requests
- expose_headers: Specifies which headers are exposed to the browser
- max_age_seconds: Specifies how long the browser should cache the preflight response

The configuration is complete and deployable, with all necessary resources and security measures in place.