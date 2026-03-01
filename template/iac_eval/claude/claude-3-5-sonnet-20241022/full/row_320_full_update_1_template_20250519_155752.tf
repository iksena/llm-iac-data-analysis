I'll help you create a Terraform configuration for a video streaming site with load balancing on AWS. This infrastructure will include:

1. A VPC with public subnets across multiple availability zones
2. An Application Load Balancer (ALB)
3. Multiple EC2 instances running in an Auto Scaling Group
4. Security Groups for the ALB and EC2 instances
5. IAM roles and policies for the instances
6. Launch template for EC2 instances

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

variable "environment" {
  default = "production"
}

variable "instance_type" {
  default = "t3.medium"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "video-streaming-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "video-streaming-igw"
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

# Security Groups
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

resource "aws_security_group" "instance" {
  name        = "instance-sg"
  description = "Security group for EC2 instances"
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

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "video-streaming-ec2-role"

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
  name = "video-streaming-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "video-streaming-"
  image_id      = "ami-0735c191cf914754d"  # Amazon Linux 2 in us-west-2
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [aws_security_group.instance.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Video Streaming Server</h1>" > /var/www/html/index.html
              EOF
  )
}

# ALB
resource "aws_lb" "app" {
  name               = "video-streaming-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# ALB Target Group
resource "aws_lb_target_group" "app" {
  name     = "video-streaming-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    timeout             = 5
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    matcher            = "200"
    unhealthy_threshold = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  desired_capacity    = 2
  max_size           = 4
  min_size           = 1
  target_group_arns  = [aws_lb_target_group.app.arn]
  vpc_zone_identifier = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "video-streaming-server"
    propagate_at_launch = true
  }
}
</iac_template>

This Terraform configuration creates a complete infrastructure for a video streaming site with the following components:

1. A VPC with two public subnets in different availability zones
2. An Application Load Balancer (ALB) that distributes incoming traffic
3. Auto Scaling Group with a minimum of 1 and maximum of 4 EC2 instances
4. Security groups for both the ALB and EC2 instances
5. IAM roles and instance profile for EC2 instances
6. Launch template with basic web server setup
7. Necessary networking components (Internet Gateway, Route Tables, etc.)

The infrastructure is designed to be highly available and scalable, with instances spread across multiple availability zones. The Auto Scaling Group will automatically adjust the number of instances based on demand (though you'll need to add scaling policies based on your specific metrics).

To deploy this infrastructure:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

Note: This is a basic setup and you might want to add:
- HTTPS support with SSL/TLS certificates
- Custom scaling policies
- Additional security measures
- Proper video streaming server software installation
- Database backend for video metadata
- Content Delivery Network (CDN) integration