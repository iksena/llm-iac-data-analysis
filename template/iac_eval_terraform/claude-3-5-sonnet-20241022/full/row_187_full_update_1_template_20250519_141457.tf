I'll help you create a Terraform configuration to launch an EC2 instance using the latest Amazon Linux 2 AMI. This configuration will:

1. Use a data source to fetch the latest Amazon Linux 2 AMI
2. Create a basic EC2 instance using that AMI
3. Set up necessary security group
4. Create required IAM role for EC2
5. Use AWS provider in us-east-1 region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create a VPC for the EC2 instance
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create a subnet in the VPC
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "main"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
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

  tags = {
    Name = "allow_ssh"
  }
}

# Create IAM role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

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

# Create IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

# Create EC2 instance
resource "aws_instance" "example" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Amazon-Linux-2-Instance"
  }
}

# Output the AMI ID
output "amazon_linux_2_ami_id" {
  value = data.aws_ami.amazon_linux_2.id
}

# Output the instance ID
output "instance_id" {
  value = aws_instance.example.id
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Uses a data source to fetch the latest Amazon Linux 2 AMI
3. Creates a VPC with a public subnet and internet gateway
4. Sets up a security group allowing SSH access
5. Creates an IAM role and instance profile for the EC2 instance
6. Launches an EC2 instance using the latest Amazon Linux 2 AMI
7. Outputs the AMI ID and instance ID

The configuration creates all necessary networking components (VPC, subnet, internet gateway, etc.) to ensure the EC2 instance is accessible. The security group allows SSH access from anywhere (port 22), and the instance is launched with a basic IAM role that can be extended with additional policies as needed.

To use this configuration:
1. Save it to a .tf file
2. Run `terraform init`
3. Run `terraform plan` to review the changes
4. Run `terraform apply` to create the infrastructure

The configuration will output the AMI ID of the latest Amazon Linux 2 AMI and the ID of the created EC2 instance.