provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
resource "aws_vpc" "neptune_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "neptune-vpc"
  }
}

# Create two subnets
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

# Create Neptune Subnet Group
resource "aws_neptune_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "Neptune Subnet Group"
  }
}

# Create Neptune Parameter Group
resource "aws_neptune_parameter_group" "neptune_param_group" {
  family = "neptune1"
  name   = "neptune-params"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }

  tags = {
    Name = "neptune-param-group"
  }
}

# Create Security Group
resource "aws_security_group" "neptune_sg" {
  name        = "neptune-security-group"
  description = "Security group for Neptune cluster"
  vpc_id      = aws_vpc.neptune_vpc.id

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet_1.cidr_block, aws_subnet.subnet_2.cidr_block]
  }

  tags = {
    Name = "neptune-sg"
  }
}

# Create Neptune Cluster
resource "aws_neptune_cluster" "neptune_cluster" {
  cluster_identifier                  = "neptune-cluster"
  engine                             = "neptune"
  backup_retention_period            = 5
  preferred_backup_window            = "07:00-09:00"
  skip_final_snapshot                = true
  vpc_security_group_ids            = [aws_security_group.neptune_sg.id]
  neptune_subnet_group_name         = aws_neptune_subnet_group.neptune_subnet_group.name
  neptune_cluster_parameter_group_name = aws_neptune_parameter_group.neptune_param_group.name

  tags = {
    Name = "neptune-cluster"
  }
}

# Create Neptune Instance
resource "aws_neptune_cluster_instance" "neptune_instance" {
  count              = 1
  cluster_identifier = aws_neptune_cluster.neptune_cluster.id
  engine             = "neptune"
  instance_class     = "db.r5.large"
  
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
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.neptune_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.neptune_route_table.id
}