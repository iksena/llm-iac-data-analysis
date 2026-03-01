I'll help you create a Terraform configuration that sets up a PostgreSQL RDS instance in AWS with the specified requirements. This configuration will:

1. Create a custom VPC with private and public subnets
2. Set up necessary security groups
3. Create a PostgreSQL RDS instance with:
   - Major version upgrade capability
   - Automatic minor version upgrades
   - Private access only
   - Sufficient storage and backup configuration

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
  default     = "YourStrongPasswordHere123!" # Change this in production
}

# VPC Configuration
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
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "postgres-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

# DB Subnet Group
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

# Security Group for PostgreSQL
resource "aws_security_group" "postgres" {
  name        = "postgres-security-group"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgres-sg"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier        = "postgres-instance"
  engine            = "postgres"
  engine_version    = "14.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "mypostgresdb"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]

  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  publicly_accessible        = false
  skip_final_snapshot       = true

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  tags = {
    Name = "postgres-rds"
  }
}

# Output the database endpoint
output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
</iac_template>

This Terraform configuration creates:

1. A VPC with public and private subnets
2. Necessary networking components (Internet Gateway, Route Table)
3. A DB subnet group spanning multiple subnets
4. A security group that allows PostgreSQL traffic (port 5432) only from within the VPC
5. A PostgreSQL RDS instance with:
   - PostgreSQL 14.7
   - 20GB storage
   - t3.micro instance type
   - Automatic minor version upgrades enabled
   - Major version upgrade capability
   - Private access only (not publicly accessible)
   - 7-day backup retention
   - Defined backup and maintenance windows

The configuration includes all necessary networking components and security settings to ensure the database is properly isolated and secured while still being accessible from within the VPC.

To use this configuration:
1. Initialize Terraform
2. Change the default password in the variables
3. Apply the configuration

Note: In a production environment, you should:
- Use a more secure method to manage database credentials (e.g., AWS Secrets Manager)
- Consider using a larger instance type
- Implement additional security measures
- Use multiple availability zones for high availability
- Consider enabling encryption at rest