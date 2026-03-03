I understand the issue now. The ALB name cannot begin with "internal-". Let me fix that and provide an improved template.

<iac_template>
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "priv-alb-vpc"
  }
}

# Private subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private-subnet-2"
  }
}

# Security Group
resource "aws_security_group" "alb_sg" {
  name_prefix = "priv-alb-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Target Group
resource "aws_lb_target_group" "private" {
  name        = "priv-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher            = "200"
  }
}

# Application Load Balancer
resource "aws_lb" "private" {
  name               = "priv-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnet_mapping {
    subnet_id            = aws_subnet.private_1.id
    private_ipv4_address = "10.0.1.100"
  }

  subnet_mapping {
    subnet_id            = aws_subnet.private_2.id
    private_ipv4_address = "10.0.2.100"
  }

  tags = {
    Name = "private-alb"
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private.arn
  }
}
</iac_template>

The main changes made to fix the issues:
1. Changed the ALB name from "internal-alb" to "priv-alb" to comply with AWS naming restrictions
2. Updated related resource names to maintain consistency
3. Kept the internal = true flag to ensure it's still an internal-facing load balancer
4. Maintained the private IP address specifications in the subnet mappings
5. Added proper template tags

This template should now deploy successfully while maintaining the requirement for an internal-facing load balancer with specified private IP addresses.