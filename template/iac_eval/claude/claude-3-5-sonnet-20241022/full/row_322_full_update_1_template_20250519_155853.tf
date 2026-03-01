I'll help you create a Terraform configuration for a video streaming site with load balancing capabilities. This infrastructure will include:

1. A VPC with public subnets across multiple availability zones
2. An Application Load Balancer (ALB) to distribute traffic
3. EC2 instances running in multiple AZs for high availability
4. Security groups for the ALB and EC2 instances
5. Route53 DNS configuration for domain routing
6. Target group for the ALB to route traffic to EC2 instances
7. IAM roles and policies for EC2 instances

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "domain_name" {
  description = "Domain name for the video streaming site"
  default     = "example-streaming.com"
}

variable "environment" {
  description = "Environment name"
  default     = "production"
}

# VPC Configuration
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "streaming-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = var.environment
  }
}

# Security Groups
resource "aws_security_group" "alb" {
  name        = "streaming-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_security_group" "ec2" {
  name        = "streaming-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

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

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "streaming-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "streaming-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instances
resource "aws_instance" "streaming_servers" {
  count = 2

  ami           = "ami-0735c191cf914754d" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  
  subnet_id                   = module.vpc.public_subnets[count.index]
  vpc_security_group_ids     = [aws_security_group.ec2.id]
  iam_instance_profile       = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "streaming-server-${count.index + 1}"
  }
}

# Application Load Balancer
resource "aws_lb" "streaming_alb" {
  name               = "streaming-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Environment = var.environment
  }
}

# ALB Target Group
resource "aws_lb_target_group" "streaming_tg" {
  name     = "streaming-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    timeout            = 5
    unhealthy_threshold = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.streaming_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.streaming_tg.arn
  }
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "streaming_tg_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.streaming_tg.arn
  target_id        = aws_instance.streaming_servers[count.index].id
  port             = 80
}

# Route53 Zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Route53 Record
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.streaming_alb.dns_name
    zone_id                = aws_lb.streaming_alb.zone_id
    evaluate_target_health = true
  }
}
</iac_template>

This Terraform configuration creates a complete infrastructure for a video streaming site with the following components:

1. A VPC with two public subnets in different availability zones
2. An Application Load Balancer with a target group
3. Two EC2 instances running Apache web server
4. Security groups for both ALB and EC2 instances
5. IAM role and instance profile for EC2 instances
6. Route53 DNS configuration with an A record pointing to the ALB
7. Necessary networking components (NAT Gateway, Internet Gateway, etc.)

The infrastructure is designed to be highly available and scalable. The EC2 instances are placed in different availability zones, and the load balancer distributes traffic between them. The security groups are configured to allow only necessary traffic, and the Route53 configuration provides DNS routing to the application.

To deploy this infrastructure, you would need to:
1. Have AWS credentials configured
2. Replace the domain name variable with your actual domain
3. Adjust the instance type and AMI ID according to your needs
4. Run terraform init, plan, and apply

Note that this is a basic setup and might need additional configuration for a production environment, such as:
- SSL/TLS certificates
- More sophisticated security measures
- Backup and monitoring solutions
- Auto Scaling Groups
- Additional IAM policies