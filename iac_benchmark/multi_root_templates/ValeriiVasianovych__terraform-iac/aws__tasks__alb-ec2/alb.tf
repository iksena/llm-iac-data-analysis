# Create Application Load Balancer
resource "aws_lb" "web_alb" {
  name               = "web-alb-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets           = data.aws_subnets.subnets.ids

  tags = {
    Environment = var.env
    Name        = "web-alb-${var.env}"
  }
}

# Create ALB Target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }

  tags = {
    Environment = var.env
    Name        = "web-tg-${var.env}"
  }
}

# Create ALB Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port             = 80
  protocol         = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Attach EC2 instances to the target group
resource "aws_lb_target_group_attachment" "web_tg_attachment" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = element(aws_instance.ubuntu_ec2.*.id, count.index)
  port             = 80
}