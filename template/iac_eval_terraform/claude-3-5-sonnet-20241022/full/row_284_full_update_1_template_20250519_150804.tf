I'll help you create a Terraform configuration that sets up an S3 bucket configured for static website hosting. This configuration will:

1. Create an S3 bucket with website hosting enabled
2. Configure the bucket for public access (required for website hosting)
3. Add a bucket policy to allow public read access
4. Configure the website hosting parameters with default index and error documents

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-terraform-website-bucket-2024"
}

# Create S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Website Bucket"
    Environment = "Production"
  }
}

# Enable website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Enable public access to bucket
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Add bucket policy to allow public read access
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website]
}

# Output the website endpoint
output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
  description = "S3 static website endpoint"
}

output "bucket_name" {
  value       = aws_s3_bucket.website_bucket.id
  description = "Name of the S3 bucket"
}
</iac_template>

This Terraform configuration creates:
1. An S3 bucket with a customizable name (default provided)
2. Website configuration for the bucket with index.html as the default document and error.html as the error document
3. Public access settings to allow website access
4. A bucket policy that allows public read access to the bucket contents
5. Outputs for the website endpoint and bucket name

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Apply the configuration: `terraform apply`
3. Upload your website files (index.html, error.html, etc.) to the bucket
4. Access your website using the endpoint URL provided in the outputs

Note: Make sure you have AWS credentials configured properly before running this configuration. Also, remember that making an S3 bucket public should be done with caution and only when necessary, such as for public website hosting.