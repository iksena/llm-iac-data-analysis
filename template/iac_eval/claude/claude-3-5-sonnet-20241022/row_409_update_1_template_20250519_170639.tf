provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "postgres_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "postgres-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "postgres_igw" {
  vpc_id = aws_vpc.postgres_vpc.id

  tags = {
    Name = "postgres-igw"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "postgres_subnet_1" {
  vpc_id            = aws_vpc.postgres_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "postgres-subnet-1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "postgres_subnet_2" {
  vpc_id            = aws_vpc.postgres_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "postgres-subnet-2"
  }
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = [aws_subnet.postgres_subnet_1.id, aws_subnet.postgres_subnet_2.id]

  tags = {
    Name = "Postgres DB subnet group"
  }
}

# Create Security Group for RDS
resource "aws_security_group" "postgres_sg" {
  name        = "postgres-security-group"
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

# Create Route Table
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

# Associate Route Table with Subnets
resource "aws_route_table_association" "postgres_rta_1" {
  subnet_id      = aws_subnet.postgres_subnet_1.id
  route_table_id = aws_route_table.postgres_route_table.id
}

resource "aws_route_table_association" "postgres_rta_2" {
  subnet_id      = aws_subnet.postgres_subnet_2.id
  route_table_id = aws_route_table.postgres_route_table.id
}

# Create RDS Instance
resource "aws_db_instance" "postgres" {
  identifier           = "postgres-db"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.r6g.large"  # Memory optimized instance
  allocated_storage   = 20
  storage_type        = "gp2"
  
  db_name             = "mypostgresdb"
  username            = "postgresadmin"
  password            = "your-secure-password123"  # Change this in production
  
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  
  publicly_accessible    = false
  skip_final_snapshot   = true
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  
  multi_az             = false
  
  tags = {
    Name = "postgres-db"
  }
}

# Output the endpoint
output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}