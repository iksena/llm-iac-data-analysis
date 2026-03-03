provider "aws" {
  region = "us-east-1"
}

# Create VPC (Neptune requires a VPC)
resource "aws_vpc" "neptune_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "neptune-vpc"
  }
}

# Create subnet group
resource "aws_subnet" "neptune_subnet_1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "neptune_subnet_2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

resource "aws_db_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.neptune_subnet_1.id, aws_subnet.neptune_subnet_2.id]

  tags = {
    Name = "Neptune DB subnet group"
  }
}

# Create security group
resource "aws_security_group" "neptune_sg" {
  name        = "neptune-security-group"
  description = "Security group for Neptune cluster"
  vpc_id      = aws_vpc.neptune_vpc.id

  ingress {
    from_port   = 8182
    to_port     = 8182
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

# Create Neptune cluster parameter group
resource "aws_neptune_cluster_parameter_group" "example" {
  family      = "neptune1"
  name        = "neptune-cluster-parameter-group"
  description = "Neptune cluster parameter group"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }
}

# Create Neptune instance parameter group
resource "aws_neptune_parameter_group" "example" {
  family      = "neptune1"
  name        = "neptune-parameter-group"
  description = "Neptune instance parameter group"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }
}

# Create Neptune cluster
resource "aws_neptune_cluster" "default" {
  cluster_identifier                  = "neptune-cluster-demo"
  engine                             = "neptune"
  backup_retention_period            = 5
  preferred_backup_window            = "07:00-09:00"
  skip_final_snapshot                = true
  vpc_security_group_ids            = [aws_security_group.neptune_sg.id]
  neptune_cluster_parameter_group_name = aws_neptune_cluster_parameter_group.example.name
  db_subnet_group_name              = aws_db_subnet_group.neptune_subnet_group.name
}

# Create Neptune instance
resource "aws_neptune_cluster_instance" "example" {
  cluster_identifier           = aws_neptune_cluster.default.id
  engine                      = "neptune"
  instance_class              = "db.r5.large"
  neptune_parameter_group_name = aws_neptune_parameter_group.example.name

  tags = {
    Name = "neptune-instance"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "neptune_igw" {
  vpc_id = aws_vpc.neptune_vpc.id

  tags = {
    Name = "neptune-igw"
  }
}

# Create Route Table
resource "aws_route_table" "neptune_route_table" {
  vpc_id = aws_vpc.neptune_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.neptune_igw.id
  }

  tags = {
    Name = "neptune-route-table"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.neptune_subnet_1.id
  route_table_id = aws_route_table.neptune_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.neptune_subnet_2.id
  route_table_id = aws_route_table.neptune_route_table.id
}