provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

resource "aws_s3_bucket" "pike_bucket" {
  bucket = "pike-680235478471"
  acl    = "private"
}

resource "aws_s3_bucket_request_payment" "pike_request_payment" {
  bucket         = aws_s3_bucket.pike_bucket.bucket
  requester_pays = true
}