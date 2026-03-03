provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-payment-configured-bucket-123"
}

# Create S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  # Enable versioning
  versioning {
    enabled = true
  }

  # Force destroy option (be careful with this in production)
  force_destroy = true
}

# Configure request payment
resource "aws_s3_bucket_request_payment_configuration" "example" {
  bucket = aws_s3_bucket.example_bucket.id
  payer  = "BucketOwner"
}

# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.example_bucket.id
}