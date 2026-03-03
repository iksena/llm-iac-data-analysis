provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket        = "my_bucket"
  force_destroy = true

  tags = {
    Name = "my_bucket"
  }
}

resource "aws_s3_bucket_metric" "my_bucket_metric" {
  bucket = aws_s3_bucket.my_bucket.id

  filter {
    prefix = ""
  }

  tags = {
    Name = "my_bucket_metric"
  }
}

resource "aws_s3_bucket_object" "my_object" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "my_object_key"
  content = "This is the content of my object."

  tags = {
    Name = "my_object"
  }
}