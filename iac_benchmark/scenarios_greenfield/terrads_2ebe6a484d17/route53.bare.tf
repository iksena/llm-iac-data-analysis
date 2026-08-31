resource "aws_route53_record" "bare_domain" {
  provider = aws.us_west_2
  zone_id  = aws_route53_zone.domain.zone_id
  name     = local.domain_name
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.bare_domain.domain_name
    zone_id                = aws_cloudfront_distribution.bare_domain.hosted_zone_id
    evaluate_target_health = false
  }
}
