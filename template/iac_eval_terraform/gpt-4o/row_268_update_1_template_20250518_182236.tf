provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website_images" {
  bucket = "my-website-images-bucket-12345"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "WebsiteImagesBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_policy" "website_images_policy" {
  bucket = aws_s3_bucket.website_images.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_images.arn}/*"
      }
    ]
  })
}