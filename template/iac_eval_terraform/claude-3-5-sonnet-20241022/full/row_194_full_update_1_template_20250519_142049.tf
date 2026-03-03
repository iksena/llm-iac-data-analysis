I'll help you create a Terraform configuration to set up an Amazon ElastiCache Redis cluster with user authentication. This configuration will:

1. Create a VPC with necessary subnets for ElastiCache
2. Create an ElastiCache subnet group
3. Create an ElastiCache parameter group
4. Create an ElastiCache user
5. Create an ElastiCache user group
6. Create a Redis cluster with authentication enabled

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
</iac_template>

This Terraform configuration creates a Redis cluster with user authentication enabled. Here's what each component does:

1. Creates a VPC with two subnets in different availability zones
2. Sets up an ElastiCache subnet group using these subnets
3. Creates a parameter group for Redis 6.x
4. Creates a Redis user with full access permissions
5. Creates a user group and associates the user with it
6. Sets up a security group allowing Redis traffic (port 6379) within the VPC
7. Creates the Redis cluster with authentication enabled via the user group
8. Sets up necessary networking components (Internet Gateway, Route Table)

To use this configuration:

1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Remember to change the password in the `aws_elasticache_user` resource to a more secure value. Also, the security group is configured to allow access only from within the VPC (10.0.0.0/16). Adjust the CIDR blocks in the security group rules according to your needs.

The Redis cluster will be accessible using the credentials:
- Username: default-user
- Password: MyPassword123!

Make sure to store these credentials securely in your application configuration.