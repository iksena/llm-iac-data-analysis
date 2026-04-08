resource "aws_lightsail_lb_stickiness_policy" "this" {
  cookie_duration = var.cookie_duration
  enabled         = var.enabled
  lb_name         = var.lb_name
  region          = var.region
}