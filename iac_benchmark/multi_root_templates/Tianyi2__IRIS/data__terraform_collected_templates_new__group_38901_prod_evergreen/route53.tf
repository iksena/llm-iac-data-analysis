resource "aws_route53_record" "evergreen_gateway_fallback" {
  name    = "evergreen.online.ntnu.no"
  zone_id = data.aws_route53_zone.online_ntnu_no.zone_id
  type    = "A"

  alias {
    name                   = aws_lb.evergreen_gateway.dns_name
    zone_id                = aws_lb.evergreen_gateway.zone_id
    evaluate_target_health = false
  }
}
