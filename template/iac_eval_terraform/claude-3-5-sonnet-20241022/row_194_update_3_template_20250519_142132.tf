provider "aws" {
  region = "us-west-2"
}

# VPC for Redis
resource "aws_vpc" "redis_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redis-vpc"
  }
}

# Subnet for Redis
resource "aws_subnet" "redis_subnet" {
  vpc_id            = aws_vpc.redis_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redis-subnet"
  }
}

# Security Group for Redis
resource "aws_security_group" "redis_sg" {
  name        = "redis-security-group"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.redis_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
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

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet.id]
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "redis_params" {
  family = "redis6.x"
  name   = "redis-params"
}

# ElastiCache User
resource "aws_elasticache_user" "redis_user" {
  user_id       = "default-user"
  user_name     = "default-user"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = ["MyPassword123!"]
}

# ElastiCache User Group
resource "aws_elasticache_user_group" "redis_user_group" {
  engine        = "REDIS"
  user_group_id = "default-user-group"
  user_ids      = [aws_elasticache_user.redis_user.user_id]
}

# ElastiCache Replication Group
resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id          = "redis-cluster"
  replication_group_description = "Redis cluster with authentication"
  engine                        = "redis"
  engine_version               = "6.x"
  node_type                    = "cache.t3.micro"
  number_cache_clusters        = 1
  parameter_group_name         = aws_elasticache_parameter_group.redis_params.name
  port                         = 6379
  security_group_ids           = [aws_security_group.redis_sg.id]
  subnet_group_name            = aws_elasticache_subnet_group.redis_subnet_group.name
  user_group_ids              = [aws_elasticache_user_group.redis_user_group.id]

  tags = {
    Name = "redis-cluster"
  }
}