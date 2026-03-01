provider "aws" {
  region = "us-east-1"
}

# Create random suffix for bucket name to ensure uniqueness
resource "random_pet" "suffix" {
  length = 2
}

# Create S3 Bucket
resource "aws_s3_bucket" "website_images" {
  bucket = "website-images-${random_pet.suffix.id}"

  tags = {
    Name        = "Website Images"
    Environment = "Production"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "website_images" {
  bucket = aws_s3_bucket.website_images.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure public access block
resource "aws_s3_bucket_public_access_block" "website_images" {
  bucket = aws_s3_bucket.website_images.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website_images" {
  bucket = aws_s3_bucket.website_images.id

  index_document {
    suffix = "index.html"
  }
}

# Configure CORS
resource "aws_s3_bucket_cors_configuration" "website_images" {
  bucket = aws_s3_bucket.website_images.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

# Bucket policy to allow public read access
resource "aws_s3_bucket_policy" "website_images" {
  bucket = aws_s3_bucket.website_images.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_images.arn}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website_images]
}

# Output the bucket name and website endpoint
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website_images.id
}

output "bucket_website_endpoint" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket.website_images.website_endpoint
}