I'll help you create a Terraform configuration that sets up a VPC with the specified networking components and security group for database access. Here's what the configuration will include:

1. A VPC with a CIDR block of 10.0.0.0/16
2. Two subnets in different availability zones
3. An Internet Gateway
4. A route table with a route to the Internet Gateway
5. A security group for database access
6. A DB subnet group combining both subnets

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type        = map(string)
  default = {
    subnet1 = "10.0.1.0/24"
    subnet2 = "10.0.2.0/24"
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
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs["subnet2"]
  availability_zone = "${data.aws_region.current.name}b"

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

# Create Security Group for Databases
resource "aws_security_group" "db" {
  name        = "database-sg"
  description = "Security group for database access"
  vpc_id      = aws_vpc.main.id

  # MySQL access
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PostgreSQL access
  ingress {
    from_port   = 5432
    to_port     = 5432
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
    Name = "database-sg"
  }
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name        = "main-db-subnet-group"
  description = "Database subnet group for main VPC"
  subnet_ids  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "main-db-subnet-group"
  }
}

# Data source for current region
data "aws_region" "current" {}

# Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.main.name
}

output "security_group_id" {
  value = aws_security_group.db.id
}
</iac_template>

This Terraform configuration creates all the necessary components for your VPC and database infrastructure. Here's a breakdown of what it does:

1. Sets up the AWS provider for the us-west-2 region
2. Defines variables for VPC and subnet CIDR blocks with default values
3. Creates a VPC with DNS support enabled
4. Creates an Internet Gateway and attaches it to the VPC
5. Creates two subnets in different availability zones
6. Sets up a route table with a route to the Internet Gateway
7. Associates the route table with both subnets
8. Creates a security group allowing inbound traffic on ports 3306 (MySQL) and 5432 (PostgreSQL)
9. Creates a DB subnet group containing both subnets
10. Includes helpful outputs for reference

The configuration is complete and deployable. It includes all necessary resources and their relationships, with no undefined references. The security group allows database access from any IP address (0.0.0.0/0) as specified, though in a production environment, you might want to restrict this to specific IP ranges.