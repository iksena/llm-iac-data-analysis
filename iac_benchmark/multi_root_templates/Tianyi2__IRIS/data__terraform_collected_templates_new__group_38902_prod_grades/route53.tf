data "aws_route53_zone" "grades" {
  name = "grades.no"
}

data "aws_lb" "evergreen_gateway" {
  name = "evergreen-prod-gateway"
}

resource "aws_route53_record" "server_alb" {
  name    = local.server_domain
  type    = "A"
  zone_id = data.aws_route53_zone.grades.zone_id

  alias {
    name                   = data.aws_lb.evergreen_gateway.dns_name
    zone_id                = data.aws_lb.evergreen_gateway.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "web_alb" {
  name    = local.web_domain
  type    = "A"
  zone_id = data.aws_route53_zone.grades.zone_id

  alias {
    name                   = data.aws_lb.evergreen_gateway.dns_name
    zone_id                = data.aws_lb.evergreen_gateway.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "web_www_alb" {
  name    = "www.${local.web_domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.grades.zone_id

  alias {
    name                   = data.aws_lb.evergreen_gateway.dns_name
    zone_id                = data.aws_lb.evergreen_gateway.zone_id
    evaluate_target_health = false
  }
}
