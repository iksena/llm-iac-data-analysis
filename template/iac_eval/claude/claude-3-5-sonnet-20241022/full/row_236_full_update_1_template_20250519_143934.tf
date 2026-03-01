I'll help you create a Terraform configuration for an AWS VPC with one public subnet and one private subnet. This configuration will include:

1. A VPC with a specified CIDR block
2. One public subnet with an Internet Gateway
3. One private subnet
4. Route tables for both subnets
5. Necessary route table associations

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
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

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}

# Create Public Route Table
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

# Create Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
</iac_template>

This Terraform configuration creates:
1. A VPC with CIDR block 10.0.0.0/16
2. An Internet Gateway attached to the VPC
3. A public subnet (10.0.1.0/24) in availability zone us-east-1a
4. A private subnet (10.0.2.0/24) in availability zone us-east-1b
5. A public route table with a route to the Internet Gateway
6. A private route table with no internet access
7. Route table associations for both subnets

The public subnet will have access to the internet through the Internet Gateway, while the private subnet will be isolated from direct internet access. All resources are properly tagged for better organization and management.