provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "pdf_bucket" {
  bucket = "my-pdf-storage-bucket-123456"
  acl    = "public-read"

  tags = {
    Name        = "PDF Storage Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "pdf_upload" {
  bucket = aws_s3_bucket.pdf_bucket.bucket
  key    = "test.pdf"
  source = "assets/test.pdf"
  acl    = "public-read"
}

output "pdf_url" {
  value = "https://${aws_s3_bucket.pdf_bucket.bucket}.s3.amazonaws.com/${aws_s3_bucket_object.pdf_upload.key}"
}