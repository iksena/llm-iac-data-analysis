resource "aws_route53_zone" "domain" {
  provider = aws.us_west_2
  name     = local.domain_name
  tags     = local.default_tags
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.us_west_2
  for_each = {
    for dvo in aws_acm_certificate.domain.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.domain.zone_id
}
