data "aws_lb_listener_rule" "this" {
  region       = var.region
  arn          = var.arn
  listener_arn = var.listener_arn
  priority     = var.priority
}