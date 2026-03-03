provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_security_group"
  description = "Security group for the load balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"] # Replace with your subnet IDs

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "example" {
  name     = "example-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0123456789abcdef0" # Replace with your VPC ID

  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

resource "aws_lb_target_group_attachment" "example" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = "10.0.1.10" # Replace with your target IP address
  port             = 80
}