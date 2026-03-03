provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
resource "aws_vpc" "postgres_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "postgres-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "postgres_igw" {
  vpc_id = aws_vpc.postgres_vpc.id

  tags = {
    Name = "postgres-igw"
  }
}

# Public Subnet
resource "aws_subnet" "postgres_subnet" {
  vpc_id                  = aws_vpc.postgres_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "postgres-subnet"
  }
}

# Route Table
resource "aws_route_table" "postgres_route_table" {
  vpc_id = aws_vpc.postgres_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.postgres_igw.id
  }

  tags = {
    Name = "postgres-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "postgres_route_assoc" {
  subnet_id      = aws_subnet.postgres_subnet.id
  route_table_id = aws_route_table.postgres_route_table.id
}

# Security Group
resource "aws_security_group" "postgres_sg" {
  name        = "postgres-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.postgres_vpc.id

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
    Name = "postgres-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = [aws_subnet.postgres_subnet.id]

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

# RDS Instance
resource "aws_db_instance" "postgres" {
  identifier        = "postgres-instance"
  engine            = "postgres"
  engine_version    = "13.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  max_allocated_storage = 50
  
  db_name  = "mypostgresdb"
  username = "postgresadmin"
  password = "your-secure-password123"

  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  maintenance_window      = "mon:00:00-mon:03:00"
  backup_window          = "03:00-06:00"
  backup_retention_period = 7

  multi_az               = false
  publicly_accessible    = true
  skip_final_snapshot    = true

  storage_type          = "gp2"
  storage_encrypted     = true

  tags = {
    Name = "postgres-instance"
  }
}

# Output the endpoint
output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}