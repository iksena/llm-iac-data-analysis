provider "aws" {
  region = "us-east-1"
}

# S3 bucket intended to receive logs (configured with log-delivery-write ACL)
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "my-unique-logging-bucket-terraform-example"
  acl    = "log-delivery-write"

  tags = {
    Name = "LoggingBucket"
  }
}

# S3 bucket with private ACL and logging enabled to send logs to the logging bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-unique-private-bucket-terraform-example"
  acl    = "private"

  logging {
    target_bucket = aws_s3_bucket.logging_bucket.bucket
    target_prefix = "log-files/"
  }

  tags = {
    Name = "PrivateBucket"
  }
}