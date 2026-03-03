provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "my-static-website-bucket-123456" # Ensure this bucket name is globally unique

  website {
    index_document = "index.html"
  }

  acl = "public-read"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-static-website-bucket-123456/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = "path/to/your/index.html" # Replace with the path to your local index.html file
  acl    = "public-read"
}