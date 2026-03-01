provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_identifier" {
  description = "The name of the Redshift cluster"
  default     = "my-redshift-cluster"
}

variable "database_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "master_username" {
  description = "Master username for the Redshift cluster"
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the Redshift cluster"
  default     = "Admin123456789"
}

# Create security group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-security-group"
  description = "Security group for Redshift cluster"

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IAM role for Redshift
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

# Attach AWSRedshiftServiceRole policy to the IAM role
resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSRedshiftServiceRole"
  role       = aws_iam_role.redshift_role.name
}

# Create Redshift cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  number_of_nodes    = 1

  skip_final_snapshot = true
  
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  iam_roles             = [aws_iam_role.redshift_role.arn]

  tags = {
    Environment = "development"
    Name        = "single-node-redshift-cluster"
  }
}