resource "aws_app_cookie_stickiness_policy" "this" {
  region        = var.region
  name          = var.name
  load_balancer = var.load_balancer
  lb_port       = var.lb_port
  cookie_name   = var.cookie_name
}