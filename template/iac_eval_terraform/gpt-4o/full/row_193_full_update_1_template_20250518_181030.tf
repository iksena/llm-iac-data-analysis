To address the business need of reducing the number of database calls, we can implement an Amazon ElastiCache cluster using Redis. Redis is an in-memory data structure store that can be used as a cache to store frequently accessed data, thereby reducing the load on the database and improving application performance. We will create an ElastiCache Redis cluster in AWS using Terraform. This setup will include the necessary security group to allow access to the cache from specific IPs or VPCs.

Below is the Terraform configuration to deploy an ElastiCache Redis cluster in AWS.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_elasticache_subnet_group" "example" {
  name       = "example-subnet-group"
  subnet_ids = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
}

resource "aws_security_group" "redis_sg" {
  name        = "redis-security-group"
  description = "Security group for Redis access"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IPs or VPC CIDR for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "my-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  subnet_group_name    = aws_elasticache_subnet_group.example.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}
```
</iac_template>

This configuration sets up a basic Redis cluster with a single node. The security group allows access to the Redis port (6379) from any IP address, but you should replace "0.0.0.0/0" with specific IP addresses or VPC CIDR blocks for better security. The subnet IDs in the `aws_elasticache_subnet_group` resource should be replaced with actual subnet IDs from your VPC.