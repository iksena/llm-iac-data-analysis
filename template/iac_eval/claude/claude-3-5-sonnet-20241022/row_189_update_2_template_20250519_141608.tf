provider "aws" {
  region = "us-west-2"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC Resource
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

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private-subnet"
  }
}

# Route Tables
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

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "fleet" {
  name        = "fleet-sg"
  description = "Security group for EC2 fleet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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

# IAM Role and Instance Profile
resource "aws_iam_role" "fleet_role" {
  name = "ec2-fleet-role"

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

resource "aws_iam_instance_profile" "fleet_profile" {
  name = "fleet-instance-profile"
  role = aws_iam_role.fleet_role.name
}

# Launch Template
resource "aws_launch_template" "fleet" {
  name_prefix   = "fleet-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [aws_security_group.fleet.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.fleet_profile.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              EOF
  )
}

# EC2 Fleet
resource "aws_ec2_fleet" "main" {
  launch_template_config {
    launch_template_specification {
      launch_template_id = aws_launch_template.fleet.id
      version           = "$Latest"
    }

    override {
      availability_zone = "us-west-2a"
      subnet_id         = aws_subnet.public.id
    }
  }

  target_capacity_specification {
    default_target_capacity_type = "on-demand"
    total_target_capacity       = 9
    on_demand_target_capacity   = 5
    spot_target_capacity        = 4
  }

  type = "maintain"

  tags = {
    Name = "main-fleet"
  }

  depends_on = [aws_launch_template.fleet]
}