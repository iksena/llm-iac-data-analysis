data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb" "chatroom" {
  name               = "${var.service_name}-alb"
  internal           = false
  load_balancer_type = "application"

  subnets         = data.aws_subnets.default.ids
  security_groups = [data.aws_security_group.default.id]

  tags = {
    name = "chatroom-alb"
  }
}

resource "aws_alb_target_group" "chatroom-tg" {
  name        = "chatroom-tg-tf"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.chatroom.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.chatroom-tg.arn
  }
}
