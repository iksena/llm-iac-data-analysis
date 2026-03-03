I'll help you create a Terraform configuration that sets up an Amazon Redshift cluster with an associated IAM role. The configuration will:

1. Create an IAM role that Redshift can assume
2. Attach necessary AWS managed policies to the IAM role
3. Create a Redshift cluster with basic configuration
4. Associate the IAM role with the Redshift cluster

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"

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

# Create Redshift subnet group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift_subnet.id]
}

# Create VPC
resource "aws_vpc" "redshift_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "redshift_subnet" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "redshift-subnet"
  }
}

# Create Redshift cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier = "redshift-cluster"
  database_name      = "redshiftdb"
  master_username    = "admin"
  master_password    = "Admin123!" # Change this in production
  node_type         = "dc2.large"
  cluster_type      = "single-node"
  
  # IAM Role association
  iam_roles = [aws_iam_role.redshift_role.arn]
  
  # Networking
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  
  # Skip final snapshot for easier cleanup
  skip_final_snapshot = true

  tags = {
    Environment = "development"
  }
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role that Redshift can assume
3. A policy attachment that gives the role necessary permissions
4. A VPC and subnet for the Redshift cluster
5. A Redshift subnet group
6. A single-node Redshift cluster with the IAM role attached

Important notes:
- The configuration creates a single-node Redshift cluster for cost efficiency
- The master password is hardcoded (you should use a more secure method in production)
- The configuration skips final snapshot for easier cleanup
- The cluster is deployed in us-east-1a availability zone
- Basic networking components (VPC, subnet) are included for a complete deployment

Remember to:
- Change the master password in production
- Adjust the node type and cluster type based on your needs
- Add additional security groups and network ACLs in production
- Consider using AWS Secrets Manager for sensitive information
- Add additional IAM policies based on your specific requirements