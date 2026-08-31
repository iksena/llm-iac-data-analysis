resource "aws_acm_certificate" "domain" {
  provider                  = aws.us_east_1
  domain_name               = local.domain_name
  subject_alternative_names = ["*.${local.domain_name}"]
  validation_method         = "DNS"
  tags                      = local.default_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "domain" {
  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.domain.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]
}
