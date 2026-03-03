provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-123456"

  cors_rule {
    allowed_methods = ["POST", "GET"]
    allowed_origins = ["https://domain.com"]
    allowed_headers = ["*"]
  }
}