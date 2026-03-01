I'll help you create a Terraform configuration that sets up a VPC with one subnet and launches an Ubuntu 20.04 EC2 instance. Here's what the configuration will do:

1. Create a VPC with CIDR block 10.0.0.0/16
2. Create one public subnet with CIDR block 10.0.1.0/24
3. Create an Internet Gateway and attach it to the VPC
4. Create a route table for internet access
5. Look up the latest Ubuntu 20.04 AMD64 AMI
6. Launch an EC2 instance using the found AMI in the created subnet

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "public-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create Route Table
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

# Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Look up Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}

# Create Security Group
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

# Create EC2 Instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Ubuntu-Server"
  }
}
</iac_template>

This configuration creates all necessary components to launch an EC2 instance in a new VPC with internet access. The instance will be launched with the latest Ubuntu 20.04 AMD64 AMI and will be accessible via SSH (port 22). The VPC is created with a CIDR block of 10.0.0.0/16, and the subnet uses 10.0.1.0/24. The configuration uses the us-west-2 (Oregon) region, but you can modify this as needed.

Note that this configuration:
1. Creates a VPC with DNS support enabled
2. Creates a public subnet that auto-assigns public IPs
3. Sets up an Internet Gateway and routing
4. Creates a security group allowing SSH access
5. Automatically looks up the latest Ubuntu 20.04 AMI
6. Launches a t2.micro instance

The instance will receive a public IP address automatically and will be accessible from the internet via SSH. Remember to use a key pair for SSH access in a production environment.