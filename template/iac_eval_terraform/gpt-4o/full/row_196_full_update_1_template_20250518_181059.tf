To authenticate an Amazon ElastiCache user with passwords, we need to create an ElastiCache cluster and configure a user with a password. This involves setting up the necessary IAM roles, security groups, and ElastiCache resources. The Terraform configuration will include the creation of an ElastiCache cluster, a user with a password, and the necessary security group to allow access to the cluster. We will use the AWS provider for this configuration.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_elasticache_user" "example_user" {
  user_id   = "example-user"
  user_name = "example-user"
  engine    = "redis"
  passwords = ["examplePassword123!"]
  access_string = "on ~* +@all"
}

resource "aws_elasticache_user_group" "example_user_group" {
  user_group_id = "example-user-group"
  engine        = "redis"
  user_ids      = [aws_elasticache_user.example_user.user_id]
}

resource "aws_security_group" "elasticache_sg" {
  name        = "elasticache-sg"
  description = "Security group for ElastiCache"

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
}

resource "aws_elasticache_subnet_group" "example" {
  name       = "example-subnet-group"
  subnet_ids = ["subnet-0123456789abcdef0"]  # Replace with your subnet ID
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "example-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  subnet_group_name    = aws_elasticache_subnet_group.example.name
  security_group_ids   = [aws_security_group.elasticache_sg.id]
}

resource "aws_elasticache_user_association" "example" {
  user_group_id = aws_elasticache_user_group.example_user_group.user_group_id
  user_id       = aws_elasticache_user.example_user.user_id
}
```
</iac_template>

This configuration sets up an ElastiCache cluster with a user that has a password for authentication. The security group allows access to the cluster on the default Redis port (6379). Make sure to replace the subnet ID with a valid one from your AWS account.