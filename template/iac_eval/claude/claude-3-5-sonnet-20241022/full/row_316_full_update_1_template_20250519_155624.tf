I'll help you create a Terraform configuration for a global video streaming infrastructure using AWS CloudFront and S3. This solution will include:

1. An S3 bucket to store video content
2. A CloudFront distribution to serve the content globally with low latency
3. An Origin Access Identity (OAI) to secure S3 access
4. Appropriate bucket policies and permissions
5. CORS configuration for the S3 bucket
6. CloudFront configuration optimized for video streaming

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"  # CloudFront requires ACM certificates in us-east-1
}

# Create S3 bucket for video content
resource "aws_s3_bucket" "video_bucket" {
  bucket = "video-streaming-content-bucket-${random_string.random.result}"
}

# Create random string for unique bucket name
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "video_bucket_versioning" {
  bucket = aws_s3_bucket.video_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure CORS for the bucket
resource "aws_s3_bucket_cors_configuration" "video_bucket_cors" {
  bucket = aws_s3_bucket.video_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Create CloudFront OAI
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for video streaming"
}

# Create bucket policy
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.video_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

# Attach bucket policy
resource "aws_s3_bucket_policy" "video_bucket_policy" {
  bucket = aws_s3_bucket.video_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "video_distribution" {
  enabled             = true
  is_ipv6_enabled    = true
  comment            = "Video streaming distribution"
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.video_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.video_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.video_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Output the CloudFront domain name
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.video_distribution.domain_name
}

# Output the S3 bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.video_bucket.id
}
</iac_template>

This Terraform configuration creates a complete video streaming infrastructure with the following components:

1. An S3 bucket with a random suffix to ensure uniqueness
2. Versioning enabled on the bucket for content protection
3. CORS configuration to allow video streaming from different origins
4. A CloudFront Origin Access Identity for secure access to the S3 bucket
5. An S3 bucket policy that only allows access through CloudFront
6. A CloudFront distribution configured for optimal video delivery:
   - IPv6 enabled
   - Global distribution (PriceClass_All)
   - HTTPS redirect
   - Appropriate cache settings
   - Compression enabled
   - No geo-restrictions

The configuration outputs the CloudFront domain name and S3 bucket name for reference.

To use this infrastructure:
1. Upload video content to the S3 bucket
2. Access the videos through the CloudFront URL
3. The content will be distributed globally through AWS's edge locations
4. CloudFront will automatically handle caching and optimal delivery

The configuration uses the default AWS provider credentials and requires appropriate AWS permissions to deploy.