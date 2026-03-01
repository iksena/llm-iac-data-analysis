I'll help you create a Terraform configuration for a global video streaming infrastructure using AWS services. This configuration will:

1. Create an S3 bucket to store video content
2. Set up CloudFront distribution with Origin Access Control (OAC) for secure content delivery
3. Configure Route53 for DNS management
4. Establish necessary IAM roles and policies
5. Set up proper bucket policies for CloudFront access

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"  # CloudFront requires ACM certificates in us-east-1
}

# Variables
variable "domain_name" {
  description = "Domain name for the video streaming service"
  type        = string
  default     = "streaming.example.com"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# S3 Bucket for video content
resource "aws_s3_bucket" "video_content" {
  bucket = "video-content-${var.environment}"
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "video_content" {
  bucket = aws_s3_bucket.video_content.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "video_content" {
  bucket = aws_s3_bucket.video_content.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "video-streaming-oac"
  description                       = "Origin Access Control for video streaming"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "video_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_All"

  origin {
    domain_name              = aws_s3_bucket.video_content.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "S3-${aws_s3_bucket.video_content.bucket}"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.video_content.bucket}"
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Route53 Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Route53 record for CloudFront
resource "aws_route53_record" "video_distribution" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.video_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.video_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "video_content" {
  bucket = aws_s3_bucket.video_content.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.video_content.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.video_distribution.arn
          }
        }
      }
    ]
  })
}
</iac_template>

This Terraform configuration creates a complete infrastructure for a video streaming service with the following components:

1. An S3 bucket to store video content with versioning enabled and public access blocked
2. A CloudFront Origin Access Control (OAC) for secure access to the S3 bucket
3. A CloudFront distribution configured to serve content globally with:
   - IPv6 support
   - HTTPS redirect
   - Proper cache behaviors
   - Global availability (PriceClass_All)
4. A Route53 zone and A record for DNS management
5. Appropriate S3 bucket policy to allow CloudFront access

The configuration uses variables with default values for flexibility and includes all necessary security measures. The infrastructure will be highly available and secure, with content delivered through CloudFront's global CDN network.

To deploy this, you would need to:
1. Have AWS credentials configured
2. Initialize Terraform
3. Apply the configuration
4. Update your domain registrar to point to the Route53 nameservers

Note: You may want to customize the domain name, environment, and other variables according to your specific needs before deployment.