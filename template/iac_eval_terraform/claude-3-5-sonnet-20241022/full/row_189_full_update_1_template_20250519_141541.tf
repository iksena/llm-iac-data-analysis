I'll help you create a Terraform configuration that sets up a VPC with public and private subnets, and an EC2 Fleet with both On-Demand and Spot instances using launch templates. The configuration will:

1. Create a VPC with public and private subnets in two availability zones
2. Set up Internet Gateway and NAT Gateway for connectivity
3. Create necessary route tables
4. Create a launch template using the latest Amazon Linux 2 AMI
5. Deploy an EC2 Fleet with 5 On-Demand and 4 Spot instances
6. Set up required IAM roles and security groups

Here's the complete Terraform configuration:

<iac_template>
```hcl
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

# VPC and Network Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
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
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "main-nat-gateway"
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
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
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

resource "aws_iam_role_policy_attachment" "fleet_policy" {
  role       = aws_iam_role.fleet_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
}

resource "aws_iam_instance_profile" "fleet_profile" {
  name = "ec2-fleet-profile"
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

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# EC2 Fleet
resource "aws_ec2_fleet" "main" {
  launch_template_config {
    launch_template_specification {
      launch_template_id = aws_launch_template.fleet.id
      version           = "$Latest"
    }

    override {
      subnet_id = aws_subnet.public[0].id
    }
    override {
      subnet_id = aws_subnet.public[1].id
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
}
```
</iac_template>

This Terraform configuration creates:
1. A VPC with 2 public and 2 private subnets across different availability zones
2. Internet Gateway and NAT Gateway for internet connectivity
3. Appropriate route tables and associations
4. A security group allowing SSH access and all outbound traffic
5. IAM role and instance profile for the EC2 instances
6. Launch template using the latest Amazon Linux 2 AMI
7. EC2 Fleet with 5 On-Demand and 4 Spot instances distributed across the public subnets

The EC2 Fleet will maintain the specified capacity of 9 instances (5 On-Demand and 4 Spot) and automatically replace any terminated instances. The instances will use t3.micro instance type and will have basic security group rules. The launch template includes a simple user data script that updates the system packages on launch.