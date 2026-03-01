To fulfill the business need of providing a Redis instance, we will deploy an Amazon ElastiCache for Redis instance using Terraform. This setup will include the necessary VPC, subnet, and security group configurations to ensure the Redis instance is accessible and secure. We will use the AWS provider to manage the resources in a specified region. The configuration will include a Redis cluster with a single node for simplicity.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "redis_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "redis-vpc"
  }
}

resource "aws_subnet" "redis_subnet" {
  vpc_id            = aws_vpc.redis_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redis-subnet"
  }
}

resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.redis_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet.id]
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  tags = {
    Name = "redis-cluster"
  }
}
```

</iac_template>

This Terraform configuration sets up a VPC, a subnet, and a security group to host an ElastiCache Redis instance. The Redis instance is configured with a single node of type `cache.t2.micro`, which is suitable for development and testing purposes. The security group allows inbound traffic on the default Redis port (6379) from any IP address, which can be adjusted for more restrictive access in a production environment.