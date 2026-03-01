I'll help you create a Terraform configuration that sets up an S3 bucket with a bucket policy to deny access from a specific IP address. 

Description:
This Terraform configuration will:
1. Create an S3 bucket named 'my_bucket'
2. Attach a bucket policy that denies all S3 actions from a specific IP address (in this case, 203.0.113.0)
3. Use the AWS provider in the us-east-1 region
4. Include proper versioning and policy formatting using jsonencode

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my_bucket"
}

# Add bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Add bucket ACL
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  bucket     = aws_s3_bucket.my_bucket.id
  acl        = "private"
}

# Add bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "DenyIPPolicy"
    Statement = [
      {
        Sid       = "IPDeny"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.my_bucket.arn,
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp": "203.0.113.0"
          }
        }
      }
    ]
  })
}
</iac_template>

This configuration creates:
1. An AWS provider configuration for the us-east-1 region
2. An S3 bucket named 'my_bucket'
3. Bucket ownership controls to ensure proper functionality
4. A private ACL for the bucket
5. A bucket policy that denies all S3 actions from IP address 203.0.113.0

The bucket policy uses the jsonencode function to properly format the policy as JSON. The policy includes:
- A version number (2012-10-17)
- A policy identifier (DenyIPPolicy)
- A statement that denies all S3 actions (s3:*) from the specified IP
- Proper resource ARNs for both the bucket and its contents
- A condition block specifying the IP address to deny

The configuration is complete and deployable, with all necessary resources properly declared and configured.