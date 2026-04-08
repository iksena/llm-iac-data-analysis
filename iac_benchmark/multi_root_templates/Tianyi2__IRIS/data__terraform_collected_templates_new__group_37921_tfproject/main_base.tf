# VPC Network creation:

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  name = "test-vpc"
  cidr = "10.0.0.0/16"

  azs                  = ["ap-south-1a", "ap-south-1b"]
  private_subnets      = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnet_names = ["private-subnet-1", "private-subnet-2"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_names  = ["public-subnet-1", "public-subnet-2"]

  private_route_table_tags = {
    "Name" = "private-route-table"
  }

  public_route_table_tags = {
    "Name" = "public-route-table"
  }

  enable_nat_gateway = true
  single_nat_gateway = true

}


# Security Group For Application Load Balancer:

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "http port to access application"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "ALB-SG"
  }
}

# Alb creation:

resource "aws_alb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = ["${aws_security_group.alb_sg.id}"]
}


# Target group for App-lb creation:

resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}


# Listener rule for app-lb:

resource "aws_lb_listener" "app_lb_listener" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_alb.app_lb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}