provider "aws" {
  region = "us-west-2"
}

# Variables
variable "redis_password" {
  description = "Password for Redis authentication"
  type        = string
  default     = "MyStr0ngP@ssw0rd123!"
  sensitive   = true
}

# VPC Data Source (assuming you have an existing VPC)
data "aws_vpc" "default" {
  default = true
}

# Subnet Data Source
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for ElastiCache
resource "aws_security_group" "redis" {
  name        = "redis-security-group"
  description = "Security group for Redis cluster"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-security-group"
  }
}

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "redis" {
  family = "redis6.x"
  name   = "redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

# ElastiCache User
resource "aws_elasticache_user" "redis_user" {
  user_id       = "default"
  user_name     = "default"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = [var.redis_password]
}

# ElastiCache User Group
resource "aws_elasticache_user_group" "redis_user_group" {
  engine        = "REDIS"
  user_group_id = "default"
  user_ids      = [aws_elasticache_user.redis_user.user_id]
}

# ElastiCache Replication Group
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "redis-cluster"
  description               = "Redis cluster with authentication"
  engine                    = "redis"
  engine_version            = "6.x"
  node_type                 = "cache.t3.micro"
  num_cache_clusters        = 1
  port                      = 6379
  parameter_group_name      = aws_elasticache_parameter_group.redis.name
  subnet_group_name         = aws_elasticache_subnet_group.redis.name
  security_group_ids        = [aws_security_group.redis.id]
  automatic_failover_enabled = false
  
  user_group_ids           = [aws_elasticache_user_group.redis_user_group.id]
  
  tags = {
    Name = "redis-cluster"
  }
}