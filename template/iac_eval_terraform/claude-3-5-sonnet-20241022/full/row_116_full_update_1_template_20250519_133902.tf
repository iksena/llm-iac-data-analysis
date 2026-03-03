I'll help you create a Terraform configuration for an S3 bucket with the specified ACL and bucket policy. This configuration will:

1. Create an S3 bucket with a unique name
2. Set up an ACL for the bucket
3. Create a bucket policy that allows s3:GetObject actions with a Referer header condition
4. Use AWS provider in us-east-1 region

Here's the complete Terraform configuration:

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Random string to ensure bucket name uniqueness
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-unique-bucket-${random_string.random.result}"
}

# S3 Bucket ACL
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  bucket     = aws_s3_bucket.website_bucket.id
  acl        = "private"
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
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
        Condition = {
          StringLike = {
            "aws:Referer" = ["http://example.com/*"]
          }
        }
      }
    ]
  })
}

# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider and required provider versions
2. Creates a random string to ensure bucket name uniqueness
3. Creates an S3 bucket with a unique name using the random string
4. Sets up bucket ownership controls to enable ACL management
5. Creates a private ACL for the bucket
6. Creates a bucket policy that:
   - Allows s3:GetObject actions
   - Applies to all principals (*)
   - Includes a condition that checks the Referer header
   - Only allows access from URLs starting with "http://example.com/"
7. Outputs the bucket name and ARN for reference

The configuration includes all necessary components and dependencies. The bucket policy includes a Referer condition that you can modify to match your specific requirements. The ACL is set to "private" for security, but the bucket policy allows specific access based on the Referer header.

Note: Remember to replace "http://example.com/*" with your actual domain if needed.