I'll help you create a Terraform configuration that sets up a VPC with the specified networking components and security group for database access. Here's what the configuration will do:

1. Create a VPC in us-east-1 region
2. Create two subnets in different availability zones
3. Set up an Internet Gateway and attach it to the VPC
4. Create a route table with a route to the Internet Gateway
5. Associate the route table with both subnets
6. Create a security group allowing MySQL (3306) and PostgreSQL (5432) access
7. Create a DB subnet group for future RDS deployments

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = map(string)
  default = {
    "subnet1" = "10.0.1.0/24"
    "subnet2" = "10.0.2.0/24"
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
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
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs["subnet1"]
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs["subnet2"]
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet2"
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

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.main.id
}

# Create Security Group
resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Security group for database access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "MySQL access"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "PostgreSQL access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "database-sg"
  }
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "database" {
  name        = "database-subnet-group"
  description = "Database subnet group"
  subnet_ids  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "database-subnet-group"
  }
}
</iac_template>

This configuration creates all the necessary components for a basic VPC setup with database access. The VPC is created with a CIDR block of 10.0.0.0/16, and two subnets are created in different availability zones (us-east-1a and us-east-1b) with CIDR blocks 10.0.1.0/24 and 10.0.2.0/24 respectively.

The security group allows incoming traffic on ports 3306 (MySQL) and 5432 (PostgreSQL) from any IP address (0.0.0.0/0). While this is permissive for demonstration purposes, in a production environment, you should restrict these to specific IP ranges.

The DB subnet group includes both subnets and can be used when creating RDS instances in this VPC. The configuration is complete and deployable, with all necessary components properly defined and connected.