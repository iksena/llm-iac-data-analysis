I'll help you create a Terraform configuration for an internal Application Load Balancer (ALB) with private IP addresses in AWS. This configuration will:

1. Create a VPC with multiple private subnets
2. Create an internal Application Load Balancer
3. Create security groups for the ALB
4. Create target groups and listeners
5. Specify private IP addresses for the load balancer subnets

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "internal-alb-vpc"
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
  name        = "internal-alb-sg"
  description = "Security group for internal ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "internal-alb-sg"
  }
}

# Target Group
resource "aws_lb_target_group" "internal" {
  name     = "internal-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

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

# Internal Application Load Balancer
resource "aws_lb" "internal" {
  name               = "internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = aws_subnet.private[*].id

  subnet_mapping {
    subnet_id            = aws_subnet.private[0].id
    private_ipv4_address = "10.0.1.100"
  }

  subnet_mapping {
    subnet_id            = aws_subnet.private[1].id
    private_ipv4_address = "10.0.2.100"
  }

  tags = {
    Name = "internal-alb"
  }
}

# Listener
resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal.arn
  }
}
</iac_template>

This Terraform configuration creates:

1. A VPC with a CIDR block of 10.0.0.0/16
2. Two private subnets in different availability zones
3. A security group allowing inbound HTTP traffic from within the VPC
4. An internal Application Load Balancer with specified private IP addresses:
   - 10.0.1.100 in the first subnet
   - 10.0.2.100 in the second subnet
5. A target group and listener for HTTP traffic on port 80

The load balancer is internal-facing (private) and will only be accessible from within the VPC. The private IP addresses are explicitly specified in the subnet mappings, which gives you control over the IP addresses assigned to the load balancer in each subnet.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: You'll need to add targets to the target group separately, as those would depend on your specific use case (EC2 instances, ECS tasks, etc.).