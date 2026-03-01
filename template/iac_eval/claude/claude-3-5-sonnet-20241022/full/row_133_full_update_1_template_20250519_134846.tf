I'll help you create a Terraform configuration to deploy an Amazon ElastiCache Redis instance in AWS. This configuration will:

1. Create a VPC with necessary networking components
2. Set up a subnet group for Redis
3. Create a security group for Redis access
4. Deploy an ElastiCache Redis instance
5. Include necessary IAM roles and permissions

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
</iac_template>

This Terraform configuration creates a Redis instance with the following features:

1. Creates a dedicated VPC with two subnets across different availability zones
2. Sets up a security group that allows Redis traffic (port 6379) within the VPC
3. Creates an ElastiCache subnet group spanning multiple availability zones
4. Deploys a Redis 6.x instance with customizable node type (defaults to cache.t3.micro)
5. Configures a parameter group with LRU cache policy
6. Outputs the Redis endpoint for connection

The configuration uses variables with default values for flexibility, and all necessary networking components are properly configured. The Redis instance will be deployed in a secure VPC with appropriate network access controls.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

You can customize the configuration by overriding the default variables either through command line or a tfvars file.