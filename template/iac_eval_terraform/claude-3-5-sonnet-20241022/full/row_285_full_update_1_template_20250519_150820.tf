I'll help you create a Terraform configuration to set up an S3 bucket for static website hosting. This configuration will:

1. Create an S3 bucket with website hosting enabled
2. Configure the bucket for public access (required for static website hosting)
3. Create a bucket policy to allow public read access
4. Set up website configuration with index.html as the index document

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
  default     = "my-static-website-bucket-12345"
}

# S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Static Website Bucket"
    Environment = "Production"
  }
}

# Enable website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Enable public access
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucket ACL
resource "aws_s3_bucket_acl" "website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

# Bucket policy
resource "aws_s3_bucket_policy" "website" {
  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]

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

This Terraform configuration creates all necessary resources for hosting a static website on S3. Here's what each part does:

1. Sets up the AWS provider for us-east-1 region
2. Defines a variable for the bucket name with a default value
3. Creates an S3 bucket
4. Enables website hosting configuration with index.html as the index document
5. Configures public access settings
6. Sets up bucket ownership controls
7. Applies public-read ACL
8. Creates a bucket policy allowing public read access
9. Outputs the website endpoint URL and bucket name

After applying this configuration:
1. You can upload your index.html file to the bucket
2. Access your website using the endpoint URL provided in the output

Note: Make sure to replace the default bucket name with your desired name. S3 bucket names must be globally unique across all AWS accounts.

To use this configuration:
1. Save it to a .tf file
2. Run `terraform init`
3. Run `terraform apply`
4. Upload your index.html file to the created bucket
5. Access your website using the endpoint URL provided in the output

Remember that this configuration makes the bucket publicly accessible, which is required for static website hosting but should be used carefully and only for content that is intended to be public.