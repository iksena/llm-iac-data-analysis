I'll help you create a Terraform configuration that sets up an AWS environment with a VPC, subnets, security group, and a PostgreSQL RDS instance according to your specifications.

Description:
This Terraform configuration will:
1. Create a VPC with CIDR block 10.0.0.0/16
2. Create two subnets in different availability zones
3. Set up an Internet Gateway and route table for public access
4. Configure a security group for database access (port 5432)
5. Deploy a PostgreSQL 15.3 RDS instance with:
   - 200GB GP2 storage
   - db.t4g.micro instance class
   - Public accessibility enabled
   - Multi-AZ deployment for high availability
6. Output the database endpoint for connectivity

Here's the complete Terraform configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
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

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "Main DB subnet group"
  }
}

# Security Group
resource "aws_security_group" "db" {
  name        = "database-sg"
  description = "Security group for PostgreSQL database"
  vpc_id      = aws_vpc.main.id

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

# RDS Instance
resource "aws_db_instance" "postgresql" {
  identifier           = "postgresql-db"
  engine              = "postgres"
  engine_version      = "15.3"
  instance_class      = "db.t4g.micro"
  allocated_storage   = 200
  storage_type        = "gp2"
  username            = "dbadmin"
  password            = "dbpassword123!" # Change this in production

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = true
  multi_az              = true

  skip_final_snapshot = true # For testing purposes, remove in production

  tags = {
    Name = "postgresql-db"
  }
}

# Output
output "database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.postgresql.endpoint
}
</iac_template>

This configuration creates all necessary components for a publicly accessible PostgreSQL RDS instance. Note that in a production environment, you should:
1. Use more secure passwords and store them in AWS Secrets Manager or similar service
2. Consider limiting the CIDR blocks in the security group to specific IP ranges
3. Enable final snapshot before deletion
4. Use encryption at rest
5. Implement backup strategies

The configuration will output the database endpoint which can be used to connect to the PostgreSQL instance.