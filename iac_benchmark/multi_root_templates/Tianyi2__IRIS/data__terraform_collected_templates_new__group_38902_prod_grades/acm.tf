module "server_certificate" {
  source = "../../modules/aws-acm-certificate"

  domain  = local.server_domain
  zone_id = data.aws_route53_zone.grades.zone_id

  providers = {
    aws.regional = aws
  }
}

module "web_certificate" {
  source = "../../modules/aws-acm-certificate"

  domain  = local.web_domain
  zone_id = data.aws_route53_zone.grades.zone_id

  providers = {
    aws.regional = aws
  }
}

module "web_www_certificate" {
  source = "../../modules/aws-acm-certificate"

  domain  = "www.${local.web_domain}"
  zone_id = data.aws_route53_zone.grades.zone_id

  providers = {
    aws.regional = aws
  }
}
