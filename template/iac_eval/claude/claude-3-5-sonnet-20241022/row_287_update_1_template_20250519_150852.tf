provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-example-payment-bucket"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "production"
}

# S3 Bucket
resource "aws_s3_bucket" "payment_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "payment_bucket_ownership" {
  bucket = aws_s3_bucket.payment_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 Bucket Request Payment Configuration
resource "aws_s3_bucket_request_payment_configuration" "payment_config" {
  bucket = aws_s3_bucket.payment_bucket.id
  payer  = "Requester"
}

# Output the bucket name
output "bucket_name" {
  value       = aws_s3_bucket.payment_bucket.id
  description = "The name of the created S3 bucket"
}

# Output the bucket payment configuration
output "payment_configuration" {
  value       = aws_s3_bucket_request_payment_configuration.payment_config.payer
  description = "The payment configuration of the bucket"
}