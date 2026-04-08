module "evergreen_gateway_certificate" {
  source = "../../modules/aws-acm-certificate"

  domain  = aws_route53_record.evergreen_gateway_fallback.name
  zone_id = data.aws_route53_zone.online_ntnu_no.zone_id

  providers = {
    aws.regional = aws
  }
}
