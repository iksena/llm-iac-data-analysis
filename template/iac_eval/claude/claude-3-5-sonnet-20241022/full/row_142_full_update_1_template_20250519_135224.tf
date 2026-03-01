I'll help you create a Terraform configuration to deploy an Amazon Redshift cluster with automated snapshots. Here's what the configuration will do:

1. Create a Redshift cluster with 1 node
2. Set up an IAM role for Redshift
3. Configure automated snapshots every 12 hours
4. Set up necessary security group for Redshift access
5. Use AWS provider in us-east-1 region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:
1. A security group allowing inbound traffic on port 5439 (Redshift port)
2. An IAM role with necessary permissions for Redshift
3. A subnet group using the default VPC and subnet
4. A single-node Redshift cluster with dc2.large node type
5. A snapshot schedule that runs every 12 hours
6. An association between the snapshot schedule and the cluster

Important notes:
- The configuration uses the default VPC and creates a subnet in us-east-1a
- The master password is hardcoded (in production, you should use variables or AWS Secrets Manager)
- The cluster is accessible from any IP (0.0.0.0/0) - in production, you should restrict this
- Automated snapshots are retained for 7 days
- The maintenance window is set to Sunday 04:00-04:30 UTC

To make this more secure for production use, you should:
1. Use variables for sensitive information
2. Restrict security group access to specific IP ranges
3. Use a custom VPC with private subnets
4. Implement encryption at rest
5. Use a more complex password policy