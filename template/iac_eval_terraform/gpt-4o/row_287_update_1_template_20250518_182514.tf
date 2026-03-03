provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-payment-config-bucket"
  acl    = "private"

  tags = {
    Name        = "ExamplePaymentConfigBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_payment_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  payer = "BucketOwner"
}