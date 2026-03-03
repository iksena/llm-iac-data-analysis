I'll help you create a Terraform configuration for an AWS RDS Aurora MySQL cluster with a proxy setup. This configuration will include:

1. VPC with public and private subnets
2. Security groups for RDS and RDS Proxy
3. RDS Aurora MySQL cluster with one writer and one reader instance
4. RDS Proxy configuration
5. Secrets Manager for database credentials
6. Required IAM roles and policies
7. Necessary networking components

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "database_name" {
  default = "mydb"
}

variable "master_username" {
  default = "admin"
}

variable "master_password" {
  default = "mypassword123!" # Change this in production
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aurora-vpc"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "aurora-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "aurora-public-subnet-${count.index + 1}"
  }
}

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Security Groups
resource "aws_security_group" "aurora" {
  name        = "aurora-security-group"
  description = "Security group for Aurora cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.proxy.id]
  }
}

resource "aws_security_group" "proxy" {
  name        = "aurora-proxy-security-group"
  description = "Security group for Aurora proxy"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Secrets Manager
resource "aws_secretsmanager_secret" "aurora_credentials" {
  name = "aurora-credentials"
}

resource "aws_secretsmanager_secret_version" "aurora_credentials" {
  secret_id = aws_secretsmanager_secret.aurora_credentials.id
  secret_string = jsonencode({
    username = var.master_username
    password = var.master_password
  })
}

# IAM Role for RDS Proxy
resource "aws_iam_role" "rds_proxy_role" {
  name = "rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "rds_proxy_policy" {
  name = "rds-proxy-policy"
  role = aws_iam_role.rds_proxy_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [aws_secretsmanager_secret.aurora_credentials.arn]
      }
    ]
  })
}

# DB Subnet Group
resource "aws_db_subnet_group" "aurora" {
  name       = "aurora-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

# Aurora Cluster
resource "aws_rds_cluster" "aurora" {
  cluster_identifier     = "aurora-cluster"
  engine                = "aurora-mysql"
  engine_version        = "8.0.mysql_aurora.3.08.0"
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  db_subnet_group_name  = aws_db_subnet_group.aurora.name
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.aurora.id]

  tags = {
    Name = "aurora-cluster"
  }
}

# Aurora Instances
resource "aws_rds_cluster_instance" "writer" {
  identifier         = "aurora-instance-1"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
}

resource "aws_rds_cluster_instance" "reader" {
  identifier         = "aurora-instance-2"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
}

# RDS Proxy
resource "aws_db_proxy" "aurora_proxy" {
  name                   = "aurora-proxy"
  debug_logging         = false
  engine_family         = "MYSQL"
  idle_client_timeout   = 1800
  require_tls           = true
  role_arn             = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.proxy.id]
  vpc_subnet_ids        = aws_subnet.private[*].id

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.aurora_credentials.arn
  }
}

resource "aws_db_proxy_default_target_group" "aurora_target_group" {
  db_proxy_name = aws_db_proxy.aurora_proxy.name

  connection_pool_config {
    max_connections_percent = 100
  }
}

resource "aws_db_proxy_target" "aurora_target" {
  db_cluster_identifier = aws_rds_cluster.aurora.id
  db_proxy_name        = aws_db_proxy.aurora_proxy.name
  target_group_name    = aws_db_proxy_default_target_group.aurora_target_group.name
}
</iac_template>

This Terraform configuration creates a complete Aurora MySQL setup with RDS Proxy. Here's what's included:

1. A VPC with two private and two public subnets across two availability zones
2. Security groups for both the Aurora cluster and RDS Proxy
3. A Secrets Manager secret to store database credentials
4. An IAM role and policy for RDS Proxy to access Secrets Manager
5. An Aurora MySQL cluster with one writer and one reader instance
6. An RDS Proxy configuration with appropriate security and networking settings
7. All necessary subnet groups and networking components

To deploy this configuration:

1. Make sure you have AWS credentials configured
2. Change the default password in the variables section
3. Run `terraform init` followed by `terraform apply`

Note: This configuration creates resources that may incur costs in your AWS account. The Aurora instances use db.r5.large instance type, which you may want to adjust based on your needs.

Also, for production use, you should:
1. Change the password to a more secure value
2. Consider enabling backup retention
3. Enable encryption at rest
4. Add more fine-grained security group rules
5. Configure proper network routing with NAT gateways and Internet gateways
6. Enable enhanced monitoring if needed