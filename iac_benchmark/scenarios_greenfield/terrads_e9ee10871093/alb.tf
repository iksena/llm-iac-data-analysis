resource "aws_lb" "main" {
  name               = "alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name_prefix = "alb-tg"
  vpc_id      = aws_vpc.main.id
  protocol    = "HTTP"
  port        = var.application_port
  target_type = "ip"

  health_check {
    enabled = true
    path    = var.application_health_check_path
  }

  lifecycle {
    create_before_destroy = true
  }
}
