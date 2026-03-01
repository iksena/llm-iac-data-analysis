To build and deploy the infrastructure for a video streaming site that distributes video content globally, we will use AWS CloudFront for content delivery, AWS S3 for storing video content, and AWS Route53 for DNS management. The S3 bucket will store the video files, and CloudFront will be used to distribute the content globally with low latency. Route53 will manage the DNS records for the domain associated with the video streaming site. We will also create an IAM role to allow CloudFront to access the S3 bucket.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "video_bucket" {
  bucket = "video-streaming-site-bucket"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_iam_role" "cloudfront_access_role" {
  name = "cloudfront-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudfront_access_policy" {
  name        = "cloudfront-access-policy"
  description = "Policy to allow CloudFront to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.video_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudfront_access_policy_attachment" {
  role       = aws_iam_role.cloudfront_access_role.name
  policy_arn = aws_iam_policy.cloudfront_access_policy.arn
}

resource "aws_cloudfront_distribution" "video_distribution" {
  origin {
    domain_name = aws_s3_bucket.video_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.video_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
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

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Access Identity for CloudFront to access S3"
}

resource "aws_route53_zone" "main" {
  name = "example.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.video_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.video_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
```
</iac_template>