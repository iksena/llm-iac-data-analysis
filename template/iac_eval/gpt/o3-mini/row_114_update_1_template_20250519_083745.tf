provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "pike-680235478471"
  acl    = "private"
  
  tags = {
    Name = "pike-680235478471"
  }
}

resource "aws_s3_bucket_public_access_block" "block_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}