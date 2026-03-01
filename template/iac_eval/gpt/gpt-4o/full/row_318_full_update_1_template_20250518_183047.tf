To build and deploy the infrastructure for a video streaming site that distributes video content globally, we will use AWS services. The infrastructure will include an S3 bucket to store video content, a CloudFront distribution to deliver the content globally, and a Route 53 hosted zone to manage DNS records for the site. We will also set up an origin access control for CloudFront to securely access the S3 bucket. Additionally, IAM roles and policies will be created to ensure secure access and operations.

Here's a detailed description of the Terraform configuration:

1. **AWS S3 Bucket**: This will store the video content. We will enable versioning and set up a bucket policy to allow access only through CloudFront.

2. **AWS CloudFront Distribution**: This will be configured to use the S3 bucket as the origin. We will set up an origin access control to restrict direct access to the S3 bucket.

3. **AWS Route 53 Hosted Zone**: This will manage the DNS records for the video streaming site. We will create a record set to point to the CloudFront distribution.

4. **IAM Roles and Policies**: These will be created to allow CloudFront to access the S3 bucket securely.

Below is the Terraform HCL configuration for the described infrastructure:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "video_content" {
  bucket = "video-streaming-site-content"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::video-streaming-site-content/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}

resource "aws_cloudfront_origin_access_control" "oac" {
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  name                              = "video-streaming-oac"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.video_content.bucket_regional_domain_name
    origin_id   = "S3-video-streaming-site-content"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-video-streaming-site-content"

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

resource "aws_route53_zone" "main" {
  name = "video-streaming-site.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
```
</iac_template>

This configuration sets up a secure and scalable infrastructure for a video streaming site using AWS services. The S3 bucket stores the video content, CloudFront distributes it globally, and Route 53 manages the DNS records.