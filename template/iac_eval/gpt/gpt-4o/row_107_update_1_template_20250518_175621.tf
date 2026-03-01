provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "sample" {
  bucket = "sample"

  versioning {
    enabled = true
  }

  expected_bucket_owner = "123456789012"
}