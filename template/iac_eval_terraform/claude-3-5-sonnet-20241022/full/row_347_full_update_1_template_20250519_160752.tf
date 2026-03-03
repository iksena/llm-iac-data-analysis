I'll help you create a Terraform configuration that sets up a PostgreSQL RDS instance in AWS with the specified requirements. This configuration will:

1. Create a custom VPC with a public and private subnet
2. Set up necessary security groups
3. Create an RDS subnet group
4. Deploy a PostgreSQL RDS instance with:
   - Specified backup window (3 AM to 6 AM)
   - 5-day backup retention
   - Appropriate instance size and storage
   - Placement in the private subnet

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  default     = "YourStrongPasswordHere123!" # Change this in production
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "postgres-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "postgres-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "postgres-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "postgres-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "postgres-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "postgres-rds-sg"
  description = "Security group for PostgreSQL RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier           = "postgres-instance"
  engine              = "postgres"
  engine_version      = "13.7"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 5
  backup_window          = "03:00-06:00"
  maintenance_window     = "Mon:06:00-Mon:09:00"

  multi_az               = false
  publicly_accessible    = false
  
  tags = {
    Name = "postgresql-database"
  }
}
</iac_template>

This Terraform configuration creates:

1. A VPC with CIDR block 10.0.0.0/16
2. A public subnet in availability zone us-west-2a
3. A private subnet in availability zone us-west-2b
4. An Internet Gateway and associated route table
5. A security group allowing PostgreSQL traffic (port 5432) from within the VPC
6. A DB subnet group spanning both subnets
7. A PostgreSQL RDS instance with:
   - db.t3.micro instance type
   - 20GB GP2 storage
   - Backup window from 3 AM to 6 AM
   - 5-day backup retention period
   - Placement in the private subnet
   - PostgreSQL version 13.7

Note: 
- Remember to change the default database password in a production environment
- The configuration uses the us-west-2 region
- The instance is not publicly accessible for security
- Multi-AZ is disabled to reduce costs (enable for production workloads)
- The maintenance window is set to follow the backup window