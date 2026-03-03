provider "aws" {
  region = "us-west-2"
}

# VPC and Networking
resource "aws_vpc" "redis_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redis-vpc"
  }
}

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

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet_1.id, aws_subnet.redis_subnet_2.id]
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "redis_params" {
  family = "redis6.x"
  name   = "redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
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
}

# ElastiCache Redis Cluster
resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "redis-cluster"
  engine              = "redis"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 1
  parameter_group_name = aws_elasticache_parameter_group.redis_params.name
  port                = 6379
  security_group_ids  = [aws_security_group.redis_sg.id]
  subnet_group_name   = aws_elasticache_subnet_group.redis_subnet_group.name

  engine_version = "6.x"

  user_group_ids = [aws_elasticache_user_group.redis_user_group.id]
}

# Internet Gateway
resource "aws_internet_gateway" "redis_igw" {
  vpc_id = aws_vpc.redis_vpc.id

  tags = {
    Name = "redis-igw"
  }
}

# Route Table
resource "aws_route_table" "redis_rt" {
  vpc_id = aws_vpc.redis_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.redis_igw.id
  }

  tags = {
    Name = "redis-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "redis_rta_1" {
  subnet_id      = aws_subnet.redis_subnet_1.id
  route_table_id = aws_route_table.redis_rt.id
}

resource "aws_route_table_association" "redis_rta_2" {
  subnet_id      = aws_subnet.redis_subnet_2.id
  route_table_id = aws_route_table.redis_rt.id
}