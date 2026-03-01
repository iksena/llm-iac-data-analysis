I'll help you create a Terraform configuration that sets up a VPC with subnets across two availability zones and a RedShift subnet group. Here's what we'll create:

1. A VPC in us-east-1 region
2. Two subnets (one in us-east-1a and another in us-east-1b)
3. Internet Gateway for the VPC
4. Route Table and associations
5. RedShift subnet group using both subnets

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

# Create Subnets
resource "aws_subnet" "subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-1a"
  }
}

resource "aws_subnet" "subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-1b"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-rt"
  }
}

# Create Route Table Associations
resource "aws_route_table_association" "subnet_1a" {
  subnet_id      = aws_subnet.subnet_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_1b" {
  subnet_id      = aws_subnet.subnet_1b.id
  route_table_id = aws_route_table.main.id
}

# Create RedShift Subnet Group
resource "aws_redshift_subnet_group" "main" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.subnet_1a.id, aws_subnet.subnet_1b.id]

  tags = {
    Name = "redshift-subnet-group"
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with CIDR block 10.0.0.0/16
2. Two subnets:
   - Subnet in us-east-1a with CIDR 10.0.1.0/24
   - Subnet in us-east-1b with CIDR 10.0.2.0/24
3. An Internet Gateway attached to the VPC
4. A Route Table with a route to the Internet Gateway
5. Route Table associations for both subnets
6. A RedShift subnet group that includes both subnets

The configuration is complete and deployable. All resources are properly declared and referenced. The AWS provider is configured for the us-east-1 region as requested. Each resource has appropriate tags for better resource management.