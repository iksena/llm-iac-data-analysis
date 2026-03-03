To fulfill the business need, we will create an AWS ElastiCache cluster using Redis. The Terraform configuration will include the necessary resources to set up an ElastiCache cluster with Redis as the engine. We will define a VPC, a subnet group, and the ElastiCache cluster itself. Additionally, we will configure the AWS provider to deploy the resources in a specified region. The configuration will also include an IAM role with the necessary permissions to manage ElastiCache resources.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.main.id]

  tags = {
    Name = "main-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  subnet_group_name    = aws_elasticache_subnet_group.main.name

  tags = {
    Name = "redis-cluster"
  }
}

resource "aws_iam_role" "elasticache_role" {
  name = "elasticache-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticache.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "elasticache_policy" {
  name = "elasticache-policy"
  role = aws_iam_role.elasticache_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticache:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
```

</iac_template>

This Terraform configuration sets up an ElastiCache cluster with Redis in a specified VPC and subnet. It also includes an IAM role with permissions to manage ElastiCache resources. The configuration is designed to be deployed in the "us-west-2" region.