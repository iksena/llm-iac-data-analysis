provider "aws" {
  region = "us-east-1"
}

# Data source for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main-nat"
  }
}

# Public Route Table
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

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
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

# IAM Role for EC2 Fleet
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

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "fleet_policy" {
  role       = aws_iam_role.fleet_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
}

# Instance Profile
resource "aws_iam_instance_profile" "fleet_profile" {
  name = "fleet-profile"
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

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "fleet-instance"
    }
  }
}

# EC2 Fleet
resource "aws_ec2_fleet" "main" {
  launch_template_config {
    launch_template_specification {
      launch_template_id = aws_launch_template.fleet.id
      version           = "$Latest"
    }
    override {
      subnet_id = aws_subnet.public.id
    }
    override {
      subnet_id = aws_subnet.private.id
    }
  }

  target_capacity_specification {
    total_target_capacity = 9
    on_demand_target_capacity = 5
    spot_target_capacity      = 4
    default_target_capacity_type = "on-demand"
  }

  type = "maintain"

  tags = {
    Name = "main-fleet"
  }
}