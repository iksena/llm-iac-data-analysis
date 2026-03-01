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