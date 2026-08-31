resource "aws_cloudfront_distribution" "dev_static_content" {
  depends_on = [
    aws_s3_bucket.dev_static_content,
  ]
  provider = aws.us_west_2
  origin {
    domain_name = aws_s3_bucket.dev_static_content.website_endpoint
    origin_id   = "s3.www.${aws_s3_bucket.dev_static_content.bucket}"
    custom_header {
      name  = "Referer"
      value = var.referer_value
    }
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["dev.${local.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3.www.${aws_s3_bucket.dev_static_content.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = local.dev_cloudfront_ttl
    default_ttl            = local.dev_cloudfront_ttl
    max_ttl                = local.dev_cloudfront_ttl
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.domain.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  tags = local.dev_tags
}
