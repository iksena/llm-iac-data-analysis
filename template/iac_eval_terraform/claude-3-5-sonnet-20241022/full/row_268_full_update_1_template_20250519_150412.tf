I'll help you create a Terraform configuration to set up an Amazon S3 bucket that can store and serve images for your website. This solution will:

1. Create an S3 bucket specifically for image storage
2. Configure the bucket for public read access (since images need to be accessible on your website)
3. Set up a bucket policy to allow public read access
4. Enable versioning for backup purposes
5. Configure the bucket for optimal image serving with appropriate CORS rules

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates an S3 bucket with the following features:

1. A unique bucket name using a random pet name suffix to avoid conflicts
2. Versioning enabled to maintain previous versions of images
3. Public read access enabled through bucket policy
4. CORS configuration to allow access from any origin
5. Static website hosting enabled
6. Appropriate public access block settings
7. Outputs for the bucket name and website endpoint

To use this bucket for your website images:
1. Upload images to the bucket
2. Images will be accessible via the S3 bucket website endpoint URL
3. You can reference images using the pattern: `http://<bucket-name>.s3-website-<region>.amazonaws.com/<image-name>`

Remember to:
- Keep your AWS credentials secure
- Only upload content you have rights to distribute
- Consider using CloudFront CDN in production for better performance (not included in this configuration)