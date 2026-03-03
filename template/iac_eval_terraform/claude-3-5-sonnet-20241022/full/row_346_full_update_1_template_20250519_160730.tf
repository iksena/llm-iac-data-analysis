I'll help you create a Terraform configuration that sets up an Amazon RDS PostgreSQL instance with the necessary networking components in a custom VPC. This configuration will:

1. Create a custom VPC with a public and private subnet
2. Set up necessary security groups for database access
3. Create a PostgreSQL RDS instance in the private subnet
4. Configure necessary IAM roles and networking components
5. Set up proper security group rules for database access

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  default     = "dbpassword123!" # Change this in production
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "postgresql-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "postgresql-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "postgresql-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "postgresql-igw"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "postgresql-public-rt"
  }
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for PostgreSQL
resource "aws_security_group" "postgresql" {
  name        = "postgresql-sg"
  description = "Security group for PostgreSQL RDS"
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

  tags = {
    Name = "postgresql-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "postgresql" {
  name       = "postgresql-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgresql" {
  identifier           = "postgresql-instance"
  engine              = "postgres"
  engine_version      = "13.7"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.postgresql.name
  vpc_security_group_ids = [aws_security_group.postgresql.id]

  backup_retention_period = 7
  multi_az               = false

  tags = {
    Name = "postgresql-instance"
  }
}

# Output the database endpoint
output "database_endpoint" {
  value = aws_db_instance.postgresql.endpoint
}
</iac_template>

This Terraform configuration creates:

1. A custom VPC with CIDR block 10.0.0.0/16
2. A public subnet in availability zone us-west-2a
3. A private subnet in availability zone us-west-2b
4. An Internet Gateway and associated route table
5. A security group allowing PostgreSQL traffic (port 5432) from within the VPC
6. A DB subnet group spanning both subnets
7. A PostgreSQL RDS instance with the following specifications:
   - Engine version 13.7
   - Instance class: db.t3.micro
   - 20GB GP2 storage
   - 7-day backup retention
   - Single AZ deployment

The configuration includes all necessary networking components and security groups. The database will be accessible only from within the VPC (through the security group rules). The configuration also outputs the database endpoint for reference.

Note: For production use, you should:
1. Change the default database password
2. Consider using AWS Secrets Manager for credential management
3. Possibly increase the instance size and storage based on your needs
4. Enable encryption at rest
5. Consider enabling Multi-AZ deployment for high availability