terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket        = "my_bucket"
  force_destroy = true
}

resource "aws_s3_bucket_metric" "my_bucket_metric" {
  bucket = aws_s3_bucket.my_bucket.id
  name   = "my_bucket_metric"
  # When no filter block is provided, the metric applies to the entire bucket.
}

resource "aws_s3_bucket_object" "my_object" {
  bucket  = aws_s3_bucket.my_bucket.id
  key     = "specific_key"
  content = "Hello, World!"
}