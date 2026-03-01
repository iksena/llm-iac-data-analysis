I'll help you create a Terraform configuration to deploy an Amazon Redshift cluster with 2 nodes and an endpoint access. The configuration will include:

1. A Redshift cluster with 2 nodes
2. Required IAM roles for Redshift
3. VPC components (VPC, subnets, security groups) for network access
4. Redshift endpoint access configuration

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "cluster_identifier" {
  description = "The Redshift cluster identifier"
  default     = "redshift-cluster-1"
}

variable "database_name" {
  description = "The name of the database"
  default     = "redshiftdb"
}

variable "master_username" {
  description = "Master username for the Redshift cluster"
  default     = "redshiftadmin"
}

variable "master_password" {
  description = "Master password for the Redshift cluster"
  default     = "RedshiftPass123!"
}

# VPC Configuration
resource "aws_vpc" "redshift_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

resource "aws_subnet" "redshift_subnet_1" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redshift-subnet-1"
  }
}

resource "aws_subnet" "redshift_subnet_2" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "redshift-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "redshift_igw" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "redshift-igw"
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

resource "aws_route_table_association" "redshift_rt_assoc_1" {
  subnet_id      = aws_subnet.redshift_subnet_1.id
  route_table_id = aws_route_table.redshift_rt.id
}

resource "aws_route_table_association" "redshift_rt_assoc_2" {
  subnet_id      = aws_subnet.redshift_subnet_2.id
  route_table_id = aws_route_table.redshift_rt.id
}

# Security Group
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-security-group"
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
}

# Subnet Group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift_subnet_1.id, aws_subnet.redshift_subnet_2.id]

  tags = {
    Name = "redshift-subnet-group"
  }
}

# IAM Role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "redshift-cluster-role"

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

resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRedshiftAllCommandsFullAccess"
  role       = aws_iam_role.redshift_role.name
}

# Redshift Cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  number_of_nodes    = 2
  cluster_type       = "multi-node"

  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  iam_roles               = [aws_iam_role.redshift_role.arn]

  skip_final_snapshot     = true
  publicly_accessible     = true

  tags = {
    Name = "redshift-cluster"
  }
}

# Redshift Endpoint Access
resource "aws_redshift_endpoint_access" "endpoint" {
  cluster_identifier = aws_redshift_cluster.redshift_cluster.cluster_identifier
  endpoint_name     = "redshift-endpoint"
  subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two subnets across different availability zones
2. Internet Gateway and route table for network connectivity
3. Security group allowing Redshift port (5439) access
4. Redshift subnet group spanning both subnets
5. IAM role with necessary permissions for Redshift
6. A Redshift cluster with 2 dc2.large nodes
7. Redshift endpoint access for connecting to the cluster

The configuration uses the us-west-2 (Oregon) region and creates a publicly accessible Redshift cluster. The cluster will be created with the specified master username and password (which you should change in production).

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Remember to change the default password in a production environment and consider implementing more restricted security group rules based on your specific needs.