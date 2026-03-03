provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "video_content" {
  bucket = "video-content-bucket"
}

resource "aws_cloudfront_origin_access_control" "s3_access_control" {
  name                               = "s3-access-control"
  origin_access_control_origin_type  = "s3"
  signing_behavior                   = "always"
  signing_protocol                   = "sigv4"
}

resource "aws_cloudfront_distribution" "video_distribution" {
  origin {
    domain_name              = aws_s3_bucket.video_content.bucket_regional_domain_name
    origin_id                = "s3_video_content_origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_access_control.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3_video_content_origin"
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_200"

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

resource "aws_route53_zone" "netflix" {
  name = "netflix.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.netflix.zone_id
  name    = "www.netflix.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.video_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.video_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.netflix.zone_id
  name    = "api.netflix.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.video_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.video_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}