provider "aws" {
  region = "us-west-2"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redis-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redis-subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "redis-subnet-2"
  }
}

# Security Group
resource "aws_security_group" "redis_sg" {
  name        = "redis-security-group"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

# Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

# Parameter Group
resource "aws_elasticache_parameter_group" "redis_params" {
  family = "redis6.x"
  name   = "redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id          = "redis-cluster"
  replication_group_description = "Redis cluster with IAM auth"
  node_type                     = "cache.t3.micro"
  port                         = 6379
  parameter_group_name         = aws_elasticache_parameter_group.redis_params.name
  subnet_group_name           = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids          = [aws_security_group.redis_sg.id]
  automatic_failover_enabled  = false
  num_cache_clusters         = 1
  engine                     = "redis"
  engine_version             = "6.x"
  transit_encryption_enabled = true
  auth_token                = null
  at_rest_encryption_enabled = true
}

# IAM User
resource "aws_iam_user" "redis_user" {
  name = "redis-user"
}

# IAM Policy
resource "aws_iam_policy" "redis_access_policy" {
  name = "redis-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticache:Connect",
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeReplicationGroups"
        ]
        Resource = aws_elasticache_replication_group.redis_cluster.arn
      }
    ]
  })
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "redis_user_policy" {
  user       = aws_iam_user.redis_user.name
  policy_arn = aws_iam_policy.redis_access_policy.arn
}

# Output the cluster endpoint
output "redis_endpoint" {
  value = aws_elasticache_replication_group.redis_cluster.primary_endpoint_address
}