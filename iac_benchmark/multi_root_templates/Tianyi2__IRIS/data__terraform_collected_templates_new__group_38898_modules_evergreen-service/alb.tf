resource "aws_lb_target_group" "this" {
  name        = var.service_name
  port        = var.target_group_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.evergreen.id

  deregistration_delay = 0

  health_check {
    path    = var.alb_health_check_path
    enabled = var.alb_health_check_enabled
    timeout = var.alb_health_check_timeout
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = data.aws_lb_listener.gateway.arn
  priority     = var.target_group_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = var.domain_names
    }
  }
}

resource "aws_lb_listener_certificate" "this" {
  count = length(var.acm_certificate_arns)

  certificate_arn = var.acm_certificate_arns[count.index]
  listener_arn    = data.aws_lb_listener.gateway.arn
}
