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
resource "aws_vpc" "redis_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redis-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "redis_igw" {
  vpc_id = aws_vpc.redis_vpc.id

  tags = {
    Name = "redis-igw"
  }
}

# Subnet
resource "aws_subnet" "redis_subnet_1" {
  vpc_id            = aws_vpc.redis_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redis-subnet-1"
  }
}

resource "aws_subnet" "redis_subnet_2" {
  vpc_id            = aws_vpc.redis_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "redis-subnet-2"
  }
}

# Subnet Group for Redis
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet_1.id, aws_subnet.redis_subnet_2.id]
}

# Security Group for Redis
resource "aws_security_group" "redis_sg" {
  name        = "redis-security-group"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.redis_vpc.id

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

# Redis Parameter Group
resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  family = "redis6.x"
  name   = "redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

# Redis Instance
resource "aws_elasticache_cluster" "redis" {
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

# Output the Redis endpoint
output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}