To build and deploy the infrastructure for a video streaming site that distributes video content globally, we will use AWS CloudFront as the Content Delivery Network (CDN) and AWS S3 as the storage for video content. The S3 bucket will store the video files, and CloudFront will be configured to distribute the content globally with low latency. We will also set up an IAM role to allow CloudFront to access the S3 bucket.

The Terraform configuration will include:
1. An S3 bucket to store video content.
2. A CloudFront distribution to serve the content from the S3 bucket.
3. An IAM role and policy to allow CloudFront to access the S3 bucket.

The configuration will be deployed in the `us-east-1` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "video_content" {
  bucket = "video-streaming-site-content"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_iam_role" "cloudfront_access" {
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

resource "aws_iam_policy" "cloudfront_s3_access" {
  name        = "cloudfront-s3-access-policy"
  description = "Policy to allow CloudFront to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.video_content.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudfront_s3_access" {
  role       = aws_iam_role.cloudfront_access.name
  policy_arn = aws_iam_policy.cloudfront_s3_access.arn
}

resource "aws_cloudfront_distribution" "video_distribution" {
  origin {
    domain_name = aws_s3_bucket.video_content.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.video_content.id}"

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
    target_origin_id = "S3-${aws_s3_bucket.video_content.id}"

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
```
</iac_template>