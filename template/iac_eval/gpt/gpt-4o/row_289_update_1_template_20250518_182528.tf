provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-owner-pays"

  # Enable bucket owner pays
  request_payer = "BucketOwner"
}