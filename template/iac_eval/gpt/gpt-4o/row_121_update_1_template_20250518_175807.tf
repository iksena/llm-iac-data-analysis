provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-private-bucket-123456"
  acl    = "private"

  logging {
    target_bucket = aws_s3_bucket.logging_bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "my-logging-bucket-123456"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_acl" "logging_bucket_acl" {
  bucket = aws_s3_bucket.logging_bucket.id
  acl    = "log-delivery-write"
}

output "private_bucket_name" {
  value = aws_s3_bucket.private_bucket.bucket
}

output "logging_bucket_name" {
  value = aws_s3_bucket.logging_bucket.bucket
}