I'll help you create a Terraform configuration for a highly available Amazon Redshift cluster spanning across multiple Availability Zones (us-east-1a and us-east-1b) in the US East 1 region. The configuration will include:

1. A VPC with subnets in two AZs
2. Security Group for Redshift
3. IAM roles and policies for Redshift
4. A Redshift cluster with multi-AZ deployment
5. Necessary networking components (Internet Gateway, Route Tables)

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "cluster_identifier" {
  default = "redshift-cluster"
}

variable "database_name" {
  default = "redshiftdb"
}

variable "master_username" {
  default = "redshiftadmin"
}

variable "master_password" {
  default = "RedshiftPass123!"
}

# VPC
resource "aws_vpc" "redshift_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "redshift_igw" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "redshift-igw"
  }
}

# Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "redshift-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "redshift-subnet-2"
  }
}

# Route Table
resource "aws_route_table" "redshift_rt" {
  vpc_id = aws_vpc.redshift_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.redshift_igw.id
  }

  tags = {
    Name = "redshift-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "rt_assoc_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.redshift_rt.id
}

resource "aws_route_table_association" "rt_assoc_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.redshift_rt.id
}

# Redshift Subnet Group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "redshift-subnet-group"
  }
}

# Security Group
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = aws_vpc.redshift_vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
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
    Name = "redshift-sg"
  }
}

# IAM Role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "redshift-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSRedshiftAllCommandsFullAccess"
  role       = aws_iam_role.redshift_role.name
}

# Redshift Cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier     = var.cluster_identifier
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  node_type            = "dc2.large"
  cluster_type         = "multi-node"
  number_of_nodes      = 2
  
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  iam_roles              = [aws_iam_role.redshift_role.arn]
  
  publicly_accessible    = false
  skip_final_snapshot    = true
  
  tags = {
    Name = "redshift-cluster"
  }
}
</iac_template>

This Terraform configuration creates a highly available Amazon Redshift cluster with the following features:

1. Creates a VPC with two subnets in different availability zones (us-east-1a and us-east-1b)
2. Sets up necessary networking components (Internet Gateway, Route Tables)
3. Creates a Redshift subnet group spanning both AZs
4. Configures security group allowing Redshift port (5439)
5. Sets up IAM role with necessary permissions for Redshift
6. Deploys a multi-node Redshift cluster with:
   - 2 nodes for high availability
   - dc2.large node type
   - Private access (not publicly accessible)
   - Spans multiple AZs through the subnet group

Note: For production use, you should:
1. Change the default password
2. Consider using AWS Secrets Manager for sensitive information
3. Restrict the security group ingress rules to specific IP ranges
4. Enable encryption and other security features
5. Adjust the node type and number based on your workload requirements