provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "environment" {
  description = "Environment name"
  default     = "production"
}

variable "redis_node_type" {
  description = "Redis node type"
  default     = "cache.t3.micro"
}

variable "redis_port" {
  description = "Redis port"
  default     = 6379
}

# VPC Configuration
resource "aws_vpc" "cache_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "cache-vpc"
  }
}

# Subnets
resource "aws_subnet" "cache_subnet_1" {
  vpc_id            = aws_vpc.cache_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "cache-subnet-1"
  }
}

resource "aws_subnet" "cache_subnet_2" {
  vpc_id            = aws_vpc.cache_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "cache-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "cache_igw" {
  vpc_id = aws_vpc.cache_vpc.id

  tags = {
    Name = "cache-igw"
  }
}

# Security Group
resource "aws_security_group" "redis_sg" {
  name        = "redis-security-group"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.cache_vpc.id

  ingress {
    from_port   = var.redis_port
    to_port     = var.redis_port
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
    Name = "redis-sg"
  }
}

# Subnet Group for ElastiCache
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.cache_subnet_1.id, aws_subnet.cache_subnet_2.id]
}

# Parameter Group
resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  family = "redis6.x"
  name   = "redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

# Redis Cluster
resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "redis-cluster"
  engine              = "redis"
  node_type           = var.redis_node_type
  num_cache_nodes     = 1
  parameter_group_name = aws_elasticache_parameter_group.redis_parameter_group.name
  port                = var.redis_port
  security_group_ids  = [aws_security_group.redis_sg.id]
  subnet_group_name   = aws_elasticache_subnet_group.redis_subnet_group.name

  tags = {
    Environment = var.environment
  }
}