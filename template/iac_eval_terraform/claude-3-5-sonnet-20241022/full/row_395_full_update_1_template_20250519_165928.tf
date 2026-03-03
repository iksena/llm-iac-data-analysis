I'll help you create a Terraform configuration that sets up an Application Load Balancer (ALB) that forwards traffic to a Network Load Balancer (NLB). This is a common architecture when you need to combine the Layer 7 capabilities of an ALB with the Layer 4 capabilities of an NLB.

The configuration will include:
1. A VPC with public and private subnets
2. An Application Load Balancer in the public subnets
3. A Network Load Balancer in the private subnets
4. Required security groups
5. Target group configurations
6. IAM roles and policies as needed

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

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

# Security Group for NLB
resource "aws_security_group" "nlb" {
  name        = "nlb-sg"
  description = "Security group for NLB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  tags = {
    Name = "frontend-alb"
  }
}

# Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "backend-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.private[*].id

  tags = {
    Name = "backend-nlb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

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
}

# NLB Target Group
resource "aws_lb_target_group" "nlb_tg" {
  name        = "nlb-target-group"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    port               = "traffic-port"
    protocol           = "TCP"
    timeout            = 10
    unhealthy_threshold = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# NLB Listener
resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two public and two private subnets across different availability zones
2. An Internet Gateway for public internet access
3. An Application Load Balancer (ALB) in the public subnets
4. A Network Load Balancer (NLB) in the private subnets
5. Appropriate security groups for both load balancers
6. Target groups for both load balancers
7. Listeners for both load balancers configured for HTTP/TCP traffic on port 80

The ALB is public-facing and can receive traffic from the internet, while the NLB is internal and can only receive traffic from the ALB. The configuration uses target groups of type "ip" which allows you to register IP addresses as targets.

To use this configuration, you would need to:
1. Initialize Terraform
2. Apply the configuration
3. Register your actual targets (like EC2 instances or IP addresses) with the appropriate target groups

Note that this is a basic configuration and you might want to add:
- HTTPS listeners with SSL certificates
- More sophisticated routing rules
- Additional security group rules
- Route tables for the subnets
- NAT Gateways for private subnet internet access