I'll help you create a Terraform configuration that sets up a CloudFront distribution with S3 origin, Route53 DNS configuration, and the necessary access controls. This configuration will:

1. Create a CloudFront distribution with specified cache behaviors and geographical restrictions
2. Set up a Route53 hosted zone for "netflix.com"
3. Create two Route53 records pointing to the CloudFront distribution
4. Configure CloudFront origin access control for secure S3 bucket access

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"  # CloudFront requires ACM certificates in us-east-1
}

# Variables
variable "domain_name" {
  description = "Domain name for the website"
  default     = "netflix.com"
}

variable "s3_bucket_domain_name" {
  description = "S3 bucket domain name"
  default     = "my-video-bucket.s3.amazonaws.com"
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "cloudfront-oac-s3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "s3_video_content_origin"
  }

  enabled             = true
  is_ipv6_enabled    = true
  default_root_object = "index.html"
  price_class         = "PriceClass_200"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_video_content_origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Route53 Records
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
</iac_template>

This configuration creates:
1. A CloudFront distribution with the specified cache behaviors, geo-restrictions, and S3 origin
2. A CloudFront Origin Access Control for secure S3 access
3. A Route53 hosted zone for netflix.com
4. Two Route53 records (www and apex domain) pointing to the CloudFront distribution

Note: You'll need to:
1. Ensure you have appropriate AWS credentials configured
2. Replace the S3 bucket domain name variable default value with your actual S3 bucket domain name
3. Be aware that creating a Route53 hosted zone for netflix.com is just an example and you should use a domain you own in practice

The configuration uses variables with default values to make it more reusable and maintainable. All resources are properly linked together using resource references.