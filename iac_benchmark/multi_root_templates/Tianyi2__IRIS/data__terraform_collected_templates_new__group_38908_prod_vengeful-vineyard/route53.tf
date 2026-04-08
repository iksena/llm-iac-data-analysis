data "aws_route53_zone" "vinstraff_no" {
  name = "vinstraff.no"
}

data "aws_lb" "evergreen_gateway" {
  name = "evergreen-prod-gateway"
}

resource "aws_route53_record" "server_alb" {
  name    = local.vengeful_server_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.vinstraff_no.zone_id

  alias {
    name                   = data.aws_lb.evergreen_gateway.dns_name
    zone_id                = data.aws_lb.evergreen_gateway.zone_id
    evaluate_target_health = false
  }
}
