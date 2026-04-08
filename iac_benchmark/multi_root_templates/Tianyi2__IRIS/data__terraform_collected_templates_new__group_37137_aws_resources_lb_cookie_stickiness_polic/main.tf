resource "aws_lb_cookie_stickiness_policy" "this" {
  region                   = var.region
  name                     = var.name
  load_balancer            = var.load_balancer
  lb_port                  = var.lb_port
  cookie_expiration_period = var.cookie_expiration_period
}