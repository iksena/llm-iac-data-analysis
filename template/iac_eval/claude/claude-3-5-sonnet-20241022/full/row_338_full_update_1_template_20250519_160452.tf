I'll help you create a Terraform configuration that sets up a VPC with subnets and a MySQL RDS instance in AWS. Here's what the configuration will include:

1. AWS provider configuration
2. VPC with CIDR block
3. Two subnets in different availability zones
4. Internet Gateway and route table
5. Security group for RDS access
6. MySQL RDS instance
7. Necessary variables with default values
8. Output for the RDS endpoint

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "db_username" {
  description = "Database administrator username"
  default     = "admin"
}

variable "db_password" {
  description = "Database administrator password"
  default     = "mypassword123!" # Change this in production
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
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

# Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-2"
  }
}

# Route Table
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

# Route Table Association
resource "aws_route_table_association" "subnet_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.main.id
}

# Security Group
resource "aws_security_group" "rds" {
  name        = "rds-security-group"
  description = "Security group for RDS MySQL instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "rds-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "main-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier           = "main-db-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  publicly_accessible    = true

  tags = {
    Name = "main-db-instance"
  }
}

# Output
output "rds_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.main.endpoint
}
</iac_template>

This Terraform configuration creates:
1. A VPC with CIDR block 10.0.0.0/16
2. Two subnets in different availability zones (us-east-1a and us-east-1b)
3. An Internet Gateway and associated route table
4. A security group allowing MySQL access (port 3306)
5. A DB subnet group spanning both subnets
6. A MySQL RDS instance that is publicly accessible
7. Necessary variables with default values
8. An output that provides the RDS endpoint

Note: For production use, you should:
1. Change the default database password
2. Consider restricting the security group's ingress rules to specific IP ranges
3. Consider using encrypted storage
4. Consider backup and maintenance windows
5. Consider using parameter groups for database configuration

The configuration is ready to be deployed using Terraform after initializing with `terraform init` and applying with `terraform apply`.