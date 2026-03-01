I'll help you create a Terraform configuration for an AWS Neptune cluster with custom parameter groups and subnet-based access control. Here's what we'll create:

1. A Neptune cluster with a custom parameter group
2. A Neptune instance within the cluster with its own parameter group
3. Security group to control access from a specific subnet
4. Necessary IAM roles and policies
5. VPC networking components (VPC, subnet, security group)

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# VPC and Networking
resource "aws_vpc" "neptune_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "neptune-vpc"
  }
}

resource "aws_subnet" "neptune_subnet" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "neptune-subnet"
  }
}

resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "example-subnet"
  }
}

# Security Group
resource "aws_security_group" "neptune_sg" {
  name        = "neptune-security-group"
  description = "Security group for Neptune cluster"
  vpc_id      = aws_vpc.neptune_vpc.id

  ingress {
    from_port       = 8182
    to_port         = 8182
    protocol        = "tcp"
    cidr_blocks     = [aws_subnet.example_subnet.cidr_block]
  }
}

# Neptune Subnet Group
resource "aws_db_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.neptune_subnet.id, aws_subnet.example_subnet.id]

  tags = {
    Name = "Neptune subnet group"
  }
}

# Neptune Cluster Parameter Group
resource "aws_neptune_cluster_parameter_group" "cluster_param_group" {
  family      = "neptune1"
  name        = "neptune-cluster-param-group"
  description = "Neptune cluster parameter group"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }
}

# Neptune Instance Parameter Group
resource "aws_neptune_parameter_group" "instance_param_group" {
  family      = "neptune1"
  name        = "neptune-instance-param-group"
  description = "Neptune instance parameter group"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }
}

# Neptune Cluster
resource "aws_neptune_cluster" "neptune_cluster" {
  cluster_identifier                  = "neptune-cluster"
  engine                             = "neptune"
  backup_retention_period            = 5
  preferred_backup_window            = "07:00-09:00"
  skip_final_snapshot                = true
  vpc_security_group_ids             = [aws_security_group.neptune_sg.id]
  neptune_cluster_parameter_group_name = aws_neptune_cluster_parameter_group.cluster_param_group.name
  db_subnet_group_name                = aws_db_subnet_group.neptune_subnet_group.name
}

# Neptune Instance
resource "aws_neptune_cluster_instance" "neptune_instance" {
  cluster_identifier = aws_neptune_cluster.neptune_cluster.id
  engine            = "neptune"
  instance_class    = "db.r5.large"
  neptune_parameter_group_name = aws_neptune_parameter_group.instance_param_group.name

  tags = {
    Name = "neptune-instance"
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two subnets (one for Neptune and one for the example subnet)
2. A security group that only allows connections from the example subnet on port 8182 (Neptune's default port)
3. A Neptune cluster parameter group with custom settings
4. A Neptune instance parameter group with custom settings
5. A Neptune cluster with the custom parameter group
6. A Neptune instance within the cluster with its own custom parameter group

The configuration ensures that:
- The Neptune cluster is only accessible from the example subnet
- Both cluster and instance have custom parameter groups
- The infrastructure is properly networked within a VPC
- The cluster has basic backup settings configured
- The instance uses a reasonable instance type (db.r5.large)

Note: You might need to add additional networking components (Internet Gateway, Route Tables) if you need internet connectivity, and you might want to adjust the CIDR blocks and other parameters according to your specific requirements.