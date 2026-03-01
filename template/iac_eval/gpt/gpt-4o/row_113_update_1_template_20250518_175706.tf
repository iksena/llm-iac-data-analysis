provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "pike_bucket" {
  bucket = "pike-680235478471"
}

resource "aws_s3_bucket_request_payment_configuration" "request_payment" {
  bucket = aws_s3_bucket.pike_bucket.id
  payer  = "Requester"
}