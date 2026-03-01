provider "aws" {
  region = "us-west-2"
}

# VPC and Networking
resource "aws_vpc" "aurora_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aurora-vpc"
  }
}

resource "aws_subnet" "aurora_subnet_1" {
  vpc_id            = aws_vpc.aurora_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "aurora-subnet-1"
  }
}

resource "aws_subnet" "aurora_subnet_2" {
  vpc_id            = aws_vpc.aurora_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "aurora-subnet-2"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.aurora_subnet_1.id, aws_subnet.aurora_subnet_2.id]

  tags = {
    Name = "Aurora DB subnet group"
  }
}

# Security Group
resource "aws_security_group" "aurora_security_group" {
  name        = "aurora-security-group"
  description = "Security group for Aurora PostgreSQL cluster"
  vpc_id      = aws_vpc.aurora_vpc.id

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
    Name = "aurora-security-group"
  }
}

# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier     = "aurora-cluster-postgresql"
  engine                = "aurora-postgresql"
  engine_version        = "13.8"
  database_name         = "mydb"
  master_username       = "admin"
  master_password       = "your-password-here"
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids = [aws_security_group.aurora_security_group.id]

  tags = {
    Name = "aurora-postgresql-cluster"
  }
}

# Aurora PostgreSQL Instance
resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier         = "aurora-instance-1"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version

  tags = {
    Name = "aurora-postgresql-instance"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "aurora_igw" {
  vpc_id = aws_vpc.aurora_vpc.id

  tags = {
    Name = "aurora-igw"
  }
}

# Route Table
resource "aws_route_table" "aurora_route_table" {
  vpc_id = aws_vpc.aurora_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aurora_igw.id
  }

  tags = {
    Name = "aurora-route-table"
  }
}

resource "aws_route_table_association" "subnet_1_association" {
  subnet_id      = aws_subnet.aurora_subnet_1.id
  route_table_id = aws_route_table.aurora_route_table.id
}

resource "aws_route_table_association" "subnet_2_association" {
  subnet_id      = aws_subnet.aurora_subnet_2.id
  route_table_id = aws_route_table.aurora_route_table.id
}