provider "aws" {
  region = "us-east-1"
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Use default subnet
data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
  default_for_az    = true
}

# Security Group for Redshift
resource "aws_security_group" "redshift" {
  name        = "redshift-sg"
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

# Attach necessary policy to the IAM role
resource "aws_iam_role_policy_attachment" "redshift_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSRedshiftServiceRole"
  role       = aws_iam_role.redshift_role.name
}

# Redshift subnet group
resource "aws_redshift_subnet_group" "redshift" {
  name       = "redshift-subnet-group"
  subnet_ids = [data.aws_subnet.default.id]

  tags = {
    Name = "redshift-subnet-group"
  }
}

# Redshift cluster
resource "aws_redshift_cluster" "cluster" {
  cluster_identifier  = "redshift-cluster"
  database_name      = "redshiftdb"
  master_username    = "admin"
  master_password    = "Admin123456789"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  number_of_nodes    = 1

  # Snapshot configuration
  automated_snapshot_retention_period = 7
  preferred_maintenance_window       = "sun:04:00-sun:04:30"
  snapshot_schedule_identifier       = aws_redshift_snapshot_schedule.schedule.identifier

  # Network configuration
  vpc_security_group_ids    = [aws_security_group.redshift.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift.name
  publicly_accessible       = false

  # IAM role
  iam_roles = [aws_iam_role.redshift_role.arn]

  skip_final_snapshot = true

  tags = {
    Environment = "production"
  }
}

# Snapshot schedule
resource "aws_redshift_snapshot_schedule" "schedule" {
  identifier = "redshift-snapshot-schedule"
  description = "Every 12 hours snapshot schedule"
  force_destroy = true
  
  schedule_definitions = [
    "0 */12 * * *"
  ]

  tags = {
    Name = "redshift-snapshot-schedule"
  }
}

# Associate snapshot schedule with cluster
resource "aws_redshift_snapshot_schedule_association" "association" {
  cluster_identifier  = aws_redshift_cluster.cluster.id
  schedule_identifier = aws_redshift_snapshot_schedule.schedule.identifier
}