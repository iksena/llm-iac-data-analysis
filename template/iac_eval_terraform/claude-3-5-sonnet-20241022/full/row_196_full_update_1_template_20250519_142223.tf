I'll help you create a Terraform configuration to set up an Amazon ElastiCache Redis cluster with user authentication using passwords. This configuration will:

1. Create an ElastiCache Redis cluster with authentication enabled
2. Create a user with password authentication
3. Set up the necessary security group
4. Configure the required subnet group

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. A security group that allows Redis traffic (port 6379) within the VPC
2. A subnet group for the Redis cluster
3. A parameter group with some basic Redis configurations
4. A Redis user with password authentication
5. A user group to manage Redis users
6. A Redis replication group (cluster) with authentication enabled

Key features:
- Uses Redis 6.x
- Creates a single-node Redis cluster (can be modified for multi-node)
- Implements password authentication
- Uses the default VPC and its subnets
- Includes necessary security group rules
- Sets up proper user access controls

To use this configuration:
1. Make sure you have AWS credentials configured
2. You can modify the `redis_password` variable to set your desired password
3. The configuration uses the default VPC, but you can modify it to use a specific VPC
4. The Redis instance type is set to cache.t3.micro, which you can change based on your needs

Note: Make sure to keep the Redis password secure and never commit it to version control. It's recommended to pass it as a variable during deployment or use AWS Secrets Manager for production environments.