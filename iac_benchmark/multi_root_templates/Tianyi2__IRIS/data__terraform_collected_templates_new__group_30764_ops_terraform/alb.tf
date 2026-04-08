resource "aws_lb" "app_lb" {
  name               = "kunlaquota-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  enable_deletion_protection = false

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-alb"
  }
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-alb-listener"
  }
}

resource "aws_lb_target_group" "app_lb_tg" {
  name     = "kunlaquota-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-alb-target-group"
  }
}