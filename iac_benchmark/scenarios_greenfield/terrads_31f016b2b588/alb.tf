resource "aws_lb_target_group" "app_tg" {
  name        = "${local.prefix}-app-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_lb_listener_rule" "app" {
  listener_arn = data.terraform_remote_state.common.outputs.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  condition {
    host_header {
      values = [
        "production.${data.terraform_remote_state.common.outputs.domain_name}",
      ]
    }
  }
}