I'll help you create a Terraform configuration to set up an Amazon Neptune cluster with a custom parameter group. This configuration will include:

1. A Neptune DB Cluster Parameter Group with custom parameters
2. A Neptune DB Cluster
3. A Neptune DB Instance
4. Required VPC networking components (VPC, subnets, security group)
5. Necessary IAM roles

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "neptune_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "neptune-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "neptune_igw" {
  vpc_id = aws_vpc.neptune_vpc.id

  tags = {
    Name = "neptune-igw"
  }
}

# Create Subnets
resource "aws_subnet" "neptune_subnet_1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "neptune_subnet_2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

# Create Subnet Group
resource "aws_neptune_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.neptune_subnet_1.id, aws_subnet.neptune_subnet_2.id]

  tags = {
    Name = "Neptune Subnet Group"
  }
}

# Create Security Group
resource "aws_security_group" "neptune_sg" {
  name        = "neptune-security-group"
  description = "Security group for Neptune cluster"
  vpc_id      = aws_vpc.neptune_vpc.id

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Neptune Cluster Parameter Group
resource "aws_neptune_cluster_parameter_group" "neptune_param_group" {
  family      = "neptune1"
  name        = "neptune-cluster-param-group"
  description = "Neptune cluster parameter group"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }

  parameter {
    name  = "neptune_enable_audit_log"
    value = "1"
  }
}

# Create Neptune Cluster
resource "aws_neptune_cluster" "neptune_cluster" {
  cluster_identifier                  = "neptune-cluster"
  engine                             = "neptune"
  backup_retention_period            = 5
  preferred_backup_window            = "07:00-09:00"
  skip_final_snapshot                = true
  vpc_security_group_ids            = [aws_security_group.neptune_sg.id]
  neptune_subnet_group_name         = aws_neptune_subnet_group.neptune_subnet_group.name
  neptune_cluster_parameter_group_name = aws_neptune_cluster_parameter_group.neptune_param_group.name

  tags = {
    Name = "neptune-cluster"
  }
}

# Create Neptune Instance
resource "aws_neptune_cluster_instance" "neptune_instance" {
  count              = 1
  cluster_identifier = aws_neptune_cluster.neptune_cluster.id
  engine             = "neptune"
  instance_class     = "db.r5.large"
  identifier         = "neptune-instance-1"

  tags = {
    Name = "neptune-instance"
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two subnets across different availability zones
2. A Neptune subnet group using these subnets
3. A security group allowing access to Neptune's default port (8182)
4. A custom Neptune cluster parameter group with some example parameters
5. A Neptune cluster using the custom parameter group
6. A Neptune instance within the cluster

The configuration includes all necessary networking components and security groups. The Neptune cluster is configured with:
- Basic backup retention (5 days)
- Skip final snapshot enabled (for easier cleanup)
- Custom parameter group with example parameters
- Instance type of db.r5.large

Note: You may need to adjust the CIDR blocks, regions, and instance types according to your specific requirements. Also, remember that Neptune clusters can be expensive to run, so make sure to clean up resources when not needed.