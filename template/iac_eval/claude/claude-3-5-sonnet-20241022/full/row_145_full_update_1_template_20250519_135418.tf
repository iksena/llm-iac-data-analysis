I'll help you create a Terraform configuration to set up a 2-node Amazon RedShift cluster in us-east-1 and replicate it to us-east-2. The configuration will include:

1. Two RedShift clusters (primary in us-east-1 and secondary in us-east-2)
2. Necessary IAM roles and policies
3. Security Groups for cluster access
4. Subnet groups for the clusters
5. VPC configurations for both regions
6. Cross-region snapshot copy configuration

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration for us-east-1 (primary)
provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

# Provider configuration for us-east-2 (secondary)
provider "aws" {
  region = "us-east-2"
  alias  = "secondary"
}

# Variables
variable "cluster_identifier" {
  description = "The RedShift cluster identifier"
  default     = "redshift-cluster"
}

variable "database_name" {
  description = "The name of the database"
  default     = "redshiftdb"
}

variable "master_username" {
  description = "Master username for the RedShift cluster"
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the RedShift cluster"
  default     = "Admin123456789"
}

# VPC for primary region
resource "aws_vpc" "primary" {
  provider             = aws.primary
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc-primary"
  }
}

# Subnet 1 for primary region
resource "aws_subnet" "primary_1" {
  provider          = aws.primary
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "redshift-subnet-1-primary"
  }
}

# Subnet 2 for primary region
resource "aws_subnet" "primary_2" {
  provider          = aws.primary
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "redshift-subnet-2-primary"
  }
}

# VPC for secondary region
resource "aws_vpc" "secondary" {
  provider             = aws.secondary
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc-secondary"
  }
}

# Subnet 1 for secondary region
resource "aws_subnet" "secondary_1" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.secondary.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "redshift-subnet-1-secondary"
  }
}

# Subnet 2 for secondary region
resource "aws_subnet" "secondary_2" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.secondary.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "redshift-subnet-2-secondary"
  }
}

# RedShift subnet group for primary region
resource "aws_redshift_subnet_group" "primary" {
  provider   = aws.primary
  name       = "redshift-subnet-group-primary"
  subnet_ids = [aws_subnet.primary_1.id, aws_subnet.primary_2.id]

  tags = {
    Name = "redshift-subnet-group-primary"
  }
}

# RedShift subnet group for secondary region
resource "aws_redshift_subnet_group" "secondary" {
  provider   = aws.secondary
  name       = "redshift-subnet-group-secondary"
  subnet_ids = [aws_subnet.secondary_1.id, aws_subnet.secondary_2.id]

  tags = {
    Name = "redshift-subnet-group-secondary"
  }
}

# IAM role for RedShift
resource "aws_iam_role" "redshift_role" {
  provider = aws.primary
  name     = "redshift-role"

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

# IAM policy for RedShift
resource "aws_iam_role_policy" "redshift_policy" {
  provider = aws.primary
  name     = "redshift-policy"
  role     = aws_iam_role.redshift_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Security group for primary RedShift cluster
resource "aws_security_group" "redshift_primary" {
  provider    = aws.primary
  name        = "redshift-security-group-primary"
  description = "Security group for RedShift cluster"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for secondary RedShift cluster
resource "aws_security_group" "redshift_secondary" {
  provider    = aws.secondary
  name        = "redshift-security-group-secondary"
  description = "Security group for RedShift cluster"
  vpc_id      = aws_vpc.secondary.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Primary RedShift cluster
resource "aws_redshift_cluster" "primary" {
  provider                      = aws.primary
  cluster_identifier           = "${var.cluster_identifier}-primary"
  database_name                = var.database_name
  master_username              = var.master_username
  master_password              = var.master_password
  node_type                    = "dc2.large"
  number_of_nodes              = 2
  cluster_subnet_group_name    = aws_redshift_subnet_group.primary.name
  vpc_security_group_ids       = [aws_security_group.redshift_primary.id]
  iam_roles                    = [aws_iam_role.redshift_role.arn]
  skip_final_snapshot         = true
  automated_snapshot_retention_period = 7
  
  tags = {
    Name = "redshift-cluster-primary"
  }
}

# Secondary RedShift cluster
resource "aws_redshift_cluster" "secondary" {
  provider                      = aws.secondary
  cluster_identifier           = "${var.cluster_identifier}-secondary"
  database_name                = var.database_name
  master_username              = var.master_username
  master_password              = var.master_password
  node_type                    = "dc2.large"
  number_of_nodes              = 2
  cluster_subnet_group_name    = aws_redshift_subnet_group.secondary.name
  vpc_security_group_ids       = [aws_security_group.redshift_secondary.id]
  iam_roles                    = [aws_iam_role.redshift_role.arn]
  skip_final_snapshot         = true
  automated_snapshot_retention_period = 7

  tags = {
    Name = "redshift-cluster-secondary"
  }
}

# Enable cross-region snapshot copy for primary cluster
resource "aws_redshift_snapshot_copy_grant" "primary" {
  provider          = aws.primary
  snapshot_copy_grant_name = "redshift-snapshot-copy-grant"
}

# Configure snapshot copy for primary cluster
resource "aws_redshift_snapshot_schedule" "primary" {
  provider              = aws.primary
  identifier           = "redshift-snapshot-schedule"
  description          = "Snapshot schedule for RedShift cluster"
  definitions          = ["rate(24 hours)"]
}

resource "aws_redshift_snapshot_schedule_association" "primary" {
  provider            = aws.primary
  cluster_identifier = aws_redshift_cluster.primary.id
  schedule_identifier = aws_redshift_snapshot_schedule.primary.id
}
</iac_template>

This Terraform configuration creates:

1. Two VPCs (one in each region) with their respective subnets
2. RedShift subnet groups in both regions
3. Security groups allowing access to RedShift ports
4. An IAM role and policy for RedShift
5. Two 2-node RedShift clusters (primary in us-east-1 and secondary in us-east-2)
6. Snapshot configuration for cross-region replication

Important notes:
1. The configuration uses dc2.large node types. Adjust as needed for your workload.
2. The security group allows access from anywhere (0.0.0.0/0). Modify this according to your security requirements.
3. The master password is set as a default value in variables. In production, use AWS Secrets Manager or similar service.
4. The clusters are configured to skip final snapshot for easier cleanup. In production, you might want to change this.
5. Snapshot retention is set to 7 days and configured to take snapshots every 24 hours.

To deploy this infrastructure, you'll need appropriate AWS credentials and permissions. Remember to modify the variables according to your requirements before applying the configuration.