provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "subnet2"
  }
}

resource "aws_eip" "gwlb" {
  vpc = true
}

resource "aws_lb" "gwlb" {
  name               = "gateway-load-balancer"
  internal           = false
  load_balancer_type = "gateway"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name = "gateway-load-balancer"
  }
}

resource "aws_lb_target_group" "gwlb_tg" {
  name     = "gwlb-target-group"
  port     = 80
  protocol = "GENEVE"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    protocol            = "GENEVE"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
  }

  tags = {
    Name = "gwlb-target-group"
  }
}

resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gwlb.arn
  port              = 6081
  protocol          = "GENEVE"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_tg.arn
  }
}

resource "aws_security_group" "gwlb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 6081
    to_port     = 6081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gwlb-security-group"
  }
}