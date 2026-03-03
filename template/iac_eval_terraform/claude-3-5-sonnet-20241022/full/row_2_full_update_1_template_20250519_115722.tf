I'll help you create a Terraform configuration that sets up an AWS Route 53 record pointing to an Elastic Load Balancer (Application Load Balancer in this case). The configuration will include:

1. An Application Load Balancer (ALB)
2. A Route 53 hosted zone
3. A Route 53 record that points to the ALB
4. Required VPC and subnet resources for the ALB
5. Required security group for the ALB

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "Domain name for the Route 53 zone"
  type        = string
  default     = "example.com"
}

# VPC and Subnet Resources
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet 2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "alb-security-group"
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

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "main"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "main"
  }
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name

  tags = {
    Name = "primary"
  }
}

# Route 53 Record
resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id               = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two public subnets in different availability zones
2. An Internet Gateway for the VPC
3. A security group allowing HTTP traffic (port 80) for the ALB
4. An Application Load Balancer named "main"
5. A Route 53 hosted zone named "primary"
6. A Route 53 A record that points to the ALB using an alias record

To use this configuration:
1. Make sure you have valid AWS credentials configured
2. Replace the default domain name in the variables section if needed
3. Run `terraform init` to initialize the working directory
4. Run `terraform plan` to see the execution plan
5. Run `terraform apply` to create the resources

Note: This configuration assumes you want to create a new hosted zone. If you already have a hosted zone, you should import it or modify the configuration to use the existing zone's ID.