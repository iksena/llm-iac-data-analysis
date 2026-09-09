resource "aws_cloudfront_distribution" "terraform_cf" {
  depends_on       = [aws_lb.terraform_elb]    
  origin {
    domain_name = aws_lb.terraform_elb.dns_name
    origin_id   = "terraform-cloudfront"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1"]
      origin_read_timeout    = 60
    }

  }

  enabled         = true
  is_ipv6_enabled = true
  web_acl_id      = aws_wafv2_web_acl.terraform_waf.arn


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "terraform-cloudfront"
    # AWS Managed Origin Policy: AllViewer
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      # type of restriction, blacklist, whitelist or none
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  lifecycle {
    ignore_changes = [viewer_certificate]
  }
  tags = merge(var.standard_tags, {
    Name                 = "${var.project_name}-${var.environment}-cloudfront"
  })
}

