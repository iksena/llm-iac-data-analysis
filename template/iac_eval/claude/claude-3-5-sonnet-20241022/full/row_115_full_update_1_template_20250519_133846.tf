I'll help you create a Terraform configuration that sets up two S3 buckets with the specified requirements. Here's what the configuration will do:

1. Create a CloudGoat data storage bucket with private access
2. Create a web data storage bucket
3. Configure bucket ownership and ACL settings
4. Upload a CSV file to the web data bucket
5. Set up public access block settings
6. Implement bucket policy for PutObject permissions

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "bucket_suffix" {
  description = "Suffix to append to bucket names"
  type        = string
  default     = "test"
}

# CloudGoat data storage bucket
resource "aws_s3_bucket" "cloudgoat_data" {
  bucket = "cloudgoat-data-${var.bucket_suffix}"
}

resource "aws_s3_bucket_ownership_controls" "cloudgoat_ownership" {
  bucket = aws_s3_bucket.cloudgoat_data.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "cloudgoat_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.cloudgoat_ownership]

  bucket = aws_s3_bucket.cloudgoat_data.id
  acl    = "private"
}

# Web data storage bucket
resource "aws_s3_bucket" "web_data" {
  bucket = "web-data-${var.bucket_suffix}"
}

resource "aws_s3_bucket_ownership_controls" "web_ownership" {
  bucket = aws_s3_bucket.web_data.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# Upload object to web data bucket
resource "aws_s3_object" "order_data" {
  bucket = aws_s3_bucket.web_data.id
  key    = "order_data2.csv"
  source = "order_data2.csv"  # Make sure this file exists in your local directory
}

# Public access block settings for web data bucket
resource "aws_s3_bucket_public_access_block" "web_access_block" {
  bucket = aws_s3_bucket.web_data.id

  ignore_public_acls      = true
  block_public_acls      = true
  restrict_public_buckets = true
  block_public_policy    = false  # Allow bucket policies
}

# Bucket policy for web data bucket
resource "aws_s3_bucket_policy" "web_bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.web_access_block]
  bucket = aws_s3_bucket.web_data.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPutObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.web_data.arn}/*"
      }
    ]
  })
}
</iac_template>

This configuration creates:
1. Two S3 buckets with dynamic names using the provided suffix
2. Proper ownership controls set to ObjectWriter
3. Private ACL for the CloudGoat bucket
4. File upload capability for the order_data2.csv file
5. Public access block settings for the web data bucket
6. A bucket policy allowing s3:PutObject actions

Note: Make sure that:
1. The order_data2.csv file exists in your local directory where you run Terraform
2. The bucket names will be unique (AWS requires globally unique bucket names)
3. You have appropriate AWS credentials configured to create these resources

The configuration uses the us-west-2 region, but you can modify this as needed.