I'll help you create a Terraform configuration for an AWS Gateway Load Balancer (GWLB). This configuration will include:

1. A Gateway Load Balancer
2. A target group for the GWLB
3. A VPC with necessary subnets
4. Required IAM roles and policies
5. Necessary variables with default values

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

variable "environment" {
  description = "Environment name"
  default     = "production"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "${var.environment}-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "${var.environment}-subnet-2"
  }
}

# Gateway Load Balancer
resource "aws_lb" "gwlb" {
  name               = "${var.environment}-gwlb"
  load_balancer_type = "gateway"
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Environment = var.environment
  }
}

# Target Group
resource "aws_lb_target_group" "gwlb_tg" {
  name        = "${var.environment}-gwlb-tg"
  port        = 6081
  protocol    = "GENEVE"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/"
    interval = 30
    timeout  = 5
  }
}

# Listener
resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gwlb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_tg.arn
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "subnet_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.main.id
}
</iac_template>

This Terraform configuration creates a Gateway Load Balancer (GWLB) in AWS with the following components:

1. A VPC with CIDR block 10.0.0.0/16
2. Two subnets in different availability zones
3. A Gateway Load Balancer spanning both subnets
4. A target group using the GENEVE protocol (port 6081)
5. A listener that forwards traffic to the target group
6. An Internet Gateway and associated route table for internet connectivity
7. Necessary route table associations

The configuration includes variables with default values and proper tagging for resources. The GWLB is set up in the us-west-2 region and can be used to deploy security appliances or other network virtual appliances that need to inspect or process traffic.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note that you'll need to register actual targets (like security appliances) with the target group after deployment for the GWLB to function properly.