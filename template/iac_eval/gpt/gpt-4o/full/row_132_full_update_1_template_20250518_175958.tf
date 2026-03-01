To provide a Memcached cluster using Terraform, we will utilize Amazon ElastiCache, which is a fully managed in-memory data store service by AWS. We will create an ElastiCache cluster with Memcached as the engine. The configuration will include setting up a VPC, subnets, and security groups to ensure the cluster is secure and accessible only from within the VPC. We will also define the necessary IAM roles and policies to allow Terraform to manage these resources.

The Terraform configuration will include:
- AWS provider configuration.
- A VPC with public and private subnets.
- Security groups to control access to the Memcached cluster.
- An ElastiCache cluster with Memcached as the engine.

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

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_security_group" "memcached_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 11211
    to_port     = 11211
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
    Name = "memcached-sg"
  }
}

resource "aws_elasticache_subnet_group" "memcached" {
  name       = "memcached-subnet-group"
  subnet_ids = [aws_subnet.private.id]

  tags = {
    Name = "memcached-subnet-group"
  }
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.5"
  subnet_group_name    = aws_elasticache_subnet_group.memcached.name
  security_group_ids   = [aws_security_group.memcached_sg.id]

  tags = {
    Name = "memcached-cluster"
  }
}
```
</iac_template>

This configuration sets up a basic Memcached cluster with two nodes in a private subnet, secured by a security group that allows traffic only from within the VPC. The cluster is deployed in the `us-west-2` region.