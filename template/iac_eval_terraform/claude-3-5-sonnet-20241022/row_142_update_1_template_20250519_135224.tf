provider "aws" {
  region = "us-east-1"
}

# Create a security group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = "redshift_security_group"
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

# Attach AWSRedshiftServiceRole policy to the IAM role
resource "aws_iam_role_policy_attachment" "redshift_service_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSRedshiftServiceRole"
  role       = aws_iam_role.redshift_role.name
}

# Create Redshift subnet group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_default_subnet.default.id]
}

# Use default VPC and subnet
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet"
  }
}

# Create Redshift cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier     = "redshift-cluster"
  database_name         = "redshiftdb"
  master_username       = "admin"
  master_password       = "Admin123456789"
  node_type            = "dc2.large"
  cluster_type         = "single-node"
  number_of_nodes      = 1
  
  # Enable automated snapshots every 12 hours
  automated_snapshot_retention_period = 7
  preferred_maintenance_window       = "sun:04:00-sun:04:30"
  automated_snapshot_schedule_identifier = aws_redshift_snapshot_schedule.snapshot_schedule.id

  # Network configuration
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  
  # IAM role
  iam_roles = [aws_iam_role.redshift_role.arn]

  skip_final_snapshot = true

  tags = {
    Environment = "production"
  }
}

# Create snapshot schedule
resource "aws_redshift_snapshot_schedule" "snapshot_schedule" {
  identifier = "redshift-snapshot-schedule"
  description = "Snapshot schedule for Redshift cluster"
  
  # Schedule snapshots every 12 hours
  schedule_definitions = [
    "rate(12 hours)"
  ]
}

# Associate snapshot schedule with cluster
resource "aws_redshift_snapshot_schedule_association" "schedule_association" {
  cluster_identifier  = aws_redshift_cluster.redshift_cluster.id
  schedule_identifier = aws_redshift_snapshot_schedule.snapshot_schedule.id
}