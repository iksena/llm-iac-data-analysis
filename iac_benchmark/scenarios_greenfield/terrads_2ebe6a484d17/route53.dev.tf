resource "aws_route53_record" "dev_static_content_a" {
  provider = aws.us_west_2
  zone_id  = aws_route53_zone.domain.zone_id
  name     = "dev.${local.domain_name}"
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.dev_static_content.domain_name
    zone_id                = aws_cloudfront_distribution.dev_static_content.hosted_zone_id
    evaluate_target_health = false
  }
}
