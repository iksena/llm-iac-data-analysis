I'll help you create a Terraform configuration to deploy an Amazon RedShift cluster with 2 nodes and attach a resource policy to it. The configuration will include:

1. A RedShift cluster with 2 nodes
2. Required IAM roles and policies
3. A resource policy for the RedShift cluster
4. Necessary security group
5. Required subnet group

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "cluster_identifier" {
  description = "The name of the RedShift cluster"
  default     = "redshift-cluster-demo"
}

variable "database_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "master_username" {
  description = "Master username for the RedShift cluster"
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the RedShift cluster"
  default     = "Admin123456789"
}

# Create VPC (since RedShift needs a VPC)
resource "aws_vpc" "redshift_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

# Create subnet
resource "aws_subnet" "redshift_subnet_1" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redshift-subnet-1"
  }
}

# Create subnet group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift_subnet_1.id]

  tags = {
    Name = "redshift-subnet-group"
  }
}

# Create security group
resource "aws_security_group" "redshift_security_group" {
  name        = "redshift-security-group"
  description = "Security group for RedShift cluster"
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

# Create IAM role for RedShift
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

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRedshiftAllCommandsFullAccess"
  role       = aws_iam_role.redshift_role.name
}

# Create RedShift cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "multi-node"
  number_of_nodes    = 2
  
  iam_roles = [aws_iam_role.redshift_role.arn]
  
  vpc_security_group_ids = [aws_security_group.redshift_security_group.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  
  skip_final_snapshot = true
}

# Create resource policy for RedShift cluster
resource "aws_redshift_cluster_iam_roles" "cluster_iam_roles" {
  cluster_identifier = aws_redshift_cluster.redshift_cluster.cluster_identifier
  iam_role_arns     = [aws_iam_role.redshift_role.arn]
}
</iac_template>

This Terraform configuration creates:
1. A VPC and subnet for the RedShift cluster
2. A security group allowing inbound traffic on port 5439 (RedShift default port)
3. An IAM role with necessary permissions for RedShift
4. A 2-node RedShift cluster with dc2.large nodes
5. A resource policy attaching the IAM role to the cluster

The configuration includes all necessary networking components and security settings. The cluster will be created in the us-west-2 region. Default values are provided for all variables, but you can override them when applying the configuration.

Note: Please make sure to:
1. Change the default password to a more secure one
2. Modify the CIDR blocks in the security group according to your needs
3. Consider enabling encryption and other security features based on your requirements
4. Adjust the node type and other parameters based on your workload requirements