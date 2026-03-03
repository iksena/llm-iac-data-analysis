provider "aws" {
  region = "us-west-2"
}

# VPC Configuration
resource "aws_vpc" "memcached_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "memcached-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.memcached_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "memcached-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.memcached_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "memcached-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.memcached_vpc.id

  tags = {
    Name = "memcached-igw"
  }
}

# Subnet Group for Memcached
resource "aws_elasticache_subnet_group" "memcached" {
  name       = "memcached-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]
}

# Security Group for Memcached
resource "aws_security_group" "memcached" {
  name        = "memcached-security-group"
  description = "Security group for Memcached cluster"
  vpc_id      = aws_vpc.memcached_vpc.id

  ingress {
    from_port   = 11211
    to_port     = 11211
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
    Name = "memcached-sg"
  }
}

# Parameter Group for Memcached
resource "aws_elasticache_parameter_group" "memcached" {
  family = "memcached1.6"
  name   = "memcached-parameters"

  parameter {
    name  = "max_item_size"
    value = "10485760"
  }
}

# Memcached Cluster
resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached-cluster"
  engine              = "memcached"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 2
  port                = 11211
  parameter_group_name = aws_elasticache_parameter_group.memcached.name
  subnet_group_name    = aws_elasticache_subnet_group.memcached.name
  security_group_ids   = [aws_security_group.memcached.id]

  tags = {
    Name = "memcached-cluster"
  }
}

# Output the cluster endpoint
output "memcached_endpoint" {
  value = aws_elasticache_cluster.memcached.cluster_address
}

# Output the cluster configuration endpoint
output "memcached_config_endpoint" {
  value = aws_elasticache_cluster.memcached.configuration_endpoint
}