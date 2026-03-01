I'll help you create a Terraform configuration that sets up an AWS Lightsail instance with access to an S3 bucket. This configuration will:

1. Create an AWS Lightsail instance
2. Create an S3 bucket
3. Create an IAM role and policy for Lightsail to access the S3 bucket
4. Attach the necessary permissions

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Environment = "dev"
  }
}

# Create S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-lightsail-bucket-${random_string.random_suffix.result}"
}

# Create random string for unique bucket name
resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create IAM Role for Lightsail
resource "aws_iam_role" "lightsail_role" {
  name = "lightsail_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lightsail.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM Policy for S3 access
resource "aws_iam_policy" "s3_access_policy" {
  name = "lightsail_s3_access_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.example_bucket.arn,
          "${aws_s3_bucket.example_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.lightsail_role.name
}

# Enable S3 bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>

This Terraform configuration creates:
1. An AWS Lightsail instance using Amazon Linux 2 with the nano bundle
2. A secure S3 bucket with versioning enabled and public access blocked
3. An IAM role that Lightsail can assume
4. An IAM policy that allows access to the S3 bucket
5. The necessary role-policy attachment

The configuration includes security best practices such as:
- Unique bucket naming using a random suffix
- Blocking public access to the S3 bucket
- Enabling versioning on the S3 bucket
- Principle of least privilege for the IAM policy

To use this configuration, you would need to:
1. Have AWS credentials configured
2. Initialize Terraform (terraform init)
3. Apply the configuration (terraform apply)

The Lightsail instance will be able to access the S3 bucket using the created IAM role and policy.