I'll help you create a Terraform configuration to set up an AWS Neptune cluster with custom parameter group and subnet-based access control. This configuration will:

1. Create a VPC with two subnets
2. Create a Neptune parameter group with custom settings
3. Set up a Neptune cluster with associated subnet group
4. Configure security group to allow access only from specified subnets

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
resource "aws_vpc" "neptune_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "neptune-vpc"
  }
}

# Create two subnets
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

# Create Neptune Subnet Group
resource "aws_neptune_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "Neptune Subnet Group"
  }
}

# Create Neptune Parameter Group
resource "aws_neptune_parameter_group" "neptune_param_group" {
  family = "neptune1"
  name   = "neptune-params"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }

  tags = {
    Name = "neptune-param-group"
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
    cidr_blocks = [aws_subnet.subnet_1.cidr_block, aws_subnet.subnet_2.cidr_block]
  }

  tags = {
    Name = "neptune-sg"
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
  neptune_cluster_parameter_group_name = aws_neptune_parameter_group.neptune_param_group.name

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
  
  tags = {
    Name = "neptune-instance"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "neptune_igw" {
  vpc_id = aws_vpc.neptune_vpc.id

  tags = {
    Name = "neptune-igw"
  }
}

# Create Route Table
resource "aws_route_table" "neptune_route_table" {
  vpc_id = aws_vpc.neptune_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.neptune_igw.id
  }

  tags = {
    Name = "neptune-route-table"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.neptune_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.neptune_route_table.id
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two subnets in different availability zones
2. A Neptune parameter group with custom settings
3. A security group that only allows connections from the two specified subnets
4. A Neptune cluster with one instance
5. Necessary networking components (Internet Gateway, Route Table)
6. A subnet group for Neptune
7. All required associations between these components

The Neptune cluster will only accept connections from the two created subnets (10.0.1.0/24 and 10.0.2.0/24) through port 8182 (Neptune's default port).

Note that this is a basic setup and you might want to add additional security measures, such as:
- Encryption at rest
- IAM authentication
- Additional parameter group settings
- More instances for high availability
- VPC endpoints for enhanced security

The configuration uses the us-east-1 region, but you can modify this as needed. The Neptune instance type is set to db.r5.large, which is a common choice for development environments, but you can adjust this based on your requirements.