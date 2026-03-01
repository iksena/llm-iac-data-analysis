I'll help you create a Terraform configuration to deploy an Amazon Redshift cluster with 2 nodes and configure concurrency scaling with a 60-minute limit. The configuration will include:

1. A Redshift cluster with 2 nodes
2. Necessary IAM roles and policies
3. Subnet group for the cluster
4. Security group for network access
5. Concurrency scaling configuration with a 60-minute limit

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
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
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the Redshift cluster"
  default     = "Admin123456789"
}

# VPC (using default VPC for simplicity)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "redshift" {
  name        = "redshift-security-group"
  description = "Security group for Redshift cluster"
  vpc_id      = data.aws_vpc.default.id

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

# Redshift subnet group
resource "aws_redshift_subnet_group" "redshift" {
  name       = "redshift-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

# IAM role for Redshift
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

# IAM role policy attachment
resource "aws_iam_role_policy_attachment" "redshift_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSRedshiftAllCommandsFullAccess"
  role       = aws_iam_role.redshift_role.name
}

# Redshift cluster
resource "aws_redshift_cluster" "cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "multi-node"
  number_of_nodes    = 2
  
  # Concurrency scaling configuration
  cluster_parameter_group_name = aws_redshift_parameter_group.concurrency_scaling.name

  # Network configuration
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift.name
  vpc_security_group_ids    = [aws_security_group.redshift.id]
  
  # IAM roles
  iam_roles = [aws_iam_role.redshift_role.arn]

  # Skip final snapshot for easier cleanup
  skip_final_snapshot = true
}

# Parameter group for concurrency scaling
resource "aws_redshift_parameter_group" "concurrency_scaling" {
  name   = "concurrency-scaling-param-group"
  family = "redshift-1.0"

  parameter {
    name  = "max_concurrency_scaling_clusters"
    value = "1"
  }

  parameter {
    name  = "concurrency_scaling_max_time"
    value = "60"
  }
}
</iac_template>

This Terraform configuration creates:

1. A Redshift cluster with 2 dc2.large nodes
2. A security group allowing access to port 5439 (Redshift's default port)
3. A subnet group using the default VPC's subnets
4. An IAM role with necessary permissions for Redshift
5. A parameter group that configures concurrency scaling with a 60-minute limit

The configuration uses the default VPC and its subnets for simplicity. In a production environment, you might want to use a dedicated VPC with proper network segmentation.

Key features of the configuration:
- Cluster Type: Multi-node with 2 nodes
- Node Type: dc2.large (you can adjust this based on your needs)
- Concurrency Scaling: Limited to 60 minutes through the parameter group
- Security: Basic security group with Redshift port access
- Authentication: Username/password authentication (you should change the default password)
- Network: Uses default VPC and creates necessary subnet groups

Remember to:
1. Change the default password in a production environment
2. Review and adjust the security group rules based on your needs
3. Consider using AWS Secrets Manager for credential management in production
4. Adjust the node type and count based on your workload requirements