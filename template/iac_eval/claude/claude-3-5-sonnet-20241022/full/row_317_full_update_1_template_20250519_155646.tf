I'll help create a Terraform configuration for a global video streaming infrastructure using AWS services. This solution will include:

1. S3 bucket to store video content
2. CloudFront distribution for global content delivery
3. Route53 for DNS management
4. SSL/TLS certificate for secure connections
5. Required IAM roles and policies

The infrastructure will enable global video content distribution with low latency and high availability. Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"  # Primary region for global services
}

# Variables
variable "domain_name" {
  description = "Domain name for the streaming service"
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

# S3 bucket policy
resource "aws_s3_bucket_policy" "video_content" {
  bucket = aws_s3_bucket.video_content.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.video_content.arn}/*"
      }
    ]
  })
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "video_content" {
  bucket = aws_s3_bucket.video_content.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Route53 zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

# Certificate validation wait
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# CloudFront OAI
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "video_distribution" {
  enabled             = true
  is_ipv6_enabled    = true
  default_root_object = "index.html"
  price_class        = "PriceClass_All"
  aliases            = [var.domain_name]

  origin {
    domain_name = aws_s3_bucket.video_content.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    compress              = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
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

# Output values
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.video_distribution.domain_name
}

output "website_domain" {
  value = var.domain_name
}
</iac_template>

This Terraform configuration creates a complete infrastructure for video streaming with the following components:

1. An S3 bucket to store video content with versioning enabled
2. A CloudFront distribution with:
   - Global edge location support
   - HTTPS-only access
   - Custom domain support
   - Proper cache behaviors for video content
3. Route53 DNS configuration with:
   - Hosted zone for the domain
   - A-record pointing to CloudFront
4. SSL/TLS certificate through ACM with automatic DNS validation
5. Proper security configurations:
   - S3 bucket policy allowing only CloudFront access
   - CloudFront Origin Access Identity
   - HTTPS enforcement
   - Modern TLS protocol support

To use this configuration:

1. Replace the default domain_name variable value with your actual domain
2. Ensure your AWS credentials are properly configured
3. Run terraform init, plan, and apply

The infrastructure will be secure, scalable, and optimized for global video content delivery.