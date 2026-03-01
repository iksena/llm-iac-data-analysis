provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-terraform-controlled-bucket"
}

# S3 Bucket Resource
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  # Force destroy for easier cleanup in test environments
  force_destroy = true
}

# S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Output the bucket name and ARN
output "bucket_name" {
  value = aws_s3_bucket.main.id
}

output "bucket_arn" {
  value = aws_s3_bucket.main.arn
}