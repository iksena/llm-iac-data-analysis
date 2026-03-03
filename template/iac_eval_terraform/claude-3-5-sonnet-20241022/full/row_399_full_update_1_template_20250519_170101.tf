I'll help you create a Terraform configuration for an Application Load Balancer (ALB) with OIDC authentication. This configuration will:

1. Create a VPC with public subnets for the ALB
2. Create an Application Load Balancer
3. Create a listener with an authenticate-oidc action
4. Set up the necessary target group
5. Configure OIDC authentication settings

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "client_id" {
  description = "The client ID for OIDC authentication"
  default     = "your-client-id"
}

variable "client_secret" {
  description = "The client secret for OIDC authentication"
  default     = "your-client-secret"
}

variable "issuer" {
  description = "The OIDC issuer URL"
  default     = "https://your-oidc-provider.com"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
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
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "public-subnet-2"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
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
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "main-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "main" {
  name     = "main-tg"
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

# ALB Listener with OIDC Authentication
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-west-2:123456789012:certificate/your-certificate-id" # Replace with your certificate ARN

  default_action {
    type = "authenticate-oidc"

    authenticate_oidc {
      authorization_endpoint = "${var.issuer}/authorize"
      client_id             = var.client_id
      client_secret         = var.client_secret
      issuer               = var.issuer
      token_endpoint       = "${var.issuer}/token"
      user_info_endpoint   = "${var.issuer}/userinfo"
    }
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
</iac_template>

This Terraform configuration creates:

1. A VPC with two public subnets across different availability zones
2. An Internet Gateway and associated route tables
3. Security groups for the ALB
4. An Application Load Balancer
5. A target group for the ALB
6. A listener with OIDC authentication configuration

To use this configuration, you need to:

1. Replace the default values for `client_id`, `client_secret`, and `issuer` variables with your actual OIDC provider details
2. Replace the certificate ARN in the listener configuration with your actual ACM certificate ARN
3. Make sure you have the necessary permissions to create these resources in your AWS account

The OIDC authentication will be performed before forwarding requests to the target group. Users will be redirected to the configured OIDC provider for authentication before accessing the application.

Note: This configuration assumes you have an SSL certificate in AWS Certificate Manager (ACM) for HTTPS termination at the ALB. Make sure to replace the certificate ARN with your actual certificate ARN.