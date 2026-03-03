I'll help you create a Terraform configuration to deploy a 2-node Amazon Redshift cluster and set up endpoint authorization. Here's what the configuration will do:

1. Create a Redshift cluster with 2 nodes
2. Set up necessary IAM roles for Redshift
3. Create a Redshift endpoint authorization for the specified AWS account
4. Configure necessary security group for Redshift access
5. Create required subnet group for Redshift deployment

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_identifier" {
  description = "The identifier for the Redshift cluster"
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
  default     = "RedshiftPass123!" # Change this in production
}

# Create VPC (since Redshift needs to be in a VPC)
resource "aws_vpc" "redshift_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "redshift_gateway" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "redshift-gateway"
  }
}

# Create Subnet 1
resource "aws_subnet" "redshift_subnet_1" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redshift-subnet-1"
  }
}

# Create Subnet 2
resource "aws_subnet" "redshift_subnet_2" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "redshift-subnet-2"
  }
}

# Create Redshift Subnet Group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift_subnet_1.id, aws_subnet.redshift_subnet_2.id]

  tags = {
    Name = "redshift-subnet-group"
  }
}

# Create Security Group
resource "aws_security_group" "redshift_security_group" {
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

# Create IAM Role for Redshift
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

# Attach AWSRedshiftAllCommandsFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "redshift_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AWSRedshiftAllCommandsFullAccess"
  role       = aws_iam_role.redshift_role.name
}

# Create Redshift Cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "multi-node"
  number_of_nodes    = 2
  
  vpc_security_group_ids = [aws_security_group.redshift_security_group.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  iam_roles          = [aws_iam_role.redshift_role.arn]
  
  skip_final_snapshot = true

  tags = {
    Name = "redshift-cluster"
  }
}

# Create Redshift Endpoint Authorization
resource "aws_redshift_endpoint_authorization" "example" {
  cluster_identifier = aws_redshift_cluster.redshift_cluster.cluster_identifier
  account           = "012345678910"
  vpc_ids           = [aws_vpc.redshift_vpc.id]
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two subnets and an internet gateway for network connectivity
2. A security group allowing Redshift traffic on port 5439
3. An IAM role with necessary permissions for Redshift
4. A 2-node Redshift cluster using dc2.large nodes
5. A Redshift endpoint authorization for the specified AWS account (012345678910)

The configuration includes all necessary networking components and security settings. The Redshift cluster will be created with the specified number of nodes and will be accessible through the security group. The endpoint authorization allows the specified AWS account to access the Redshift cluster.

Note: For production use, you should:
1. Change the master password to something more secure
2. Consider using AWS Secrets Manager for sensitive values
3. Adjust the security group rules according to your security requirements
4. Review and adjust the node type based on your performance needs
5. Consider enabling encryption and other security features