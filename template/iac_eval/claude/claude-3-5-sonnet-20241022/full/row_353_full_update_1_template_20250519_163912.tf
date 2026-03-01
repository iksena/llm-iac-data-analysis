I'll help you create a Terraform configuration for an AWS RDS Aurora MySQL cluster with a proxy setup. This configuration will include:

1. VPC with public and private subnets
2. Security groups for the Aurora cluster and proxy
3. RDS Aurora MySQL cluster
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
  description = "Name of the database"
  default     = "myappdb"
}

variable "master_username" {
  description = "Master username for the database"
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the database"
  default     = "YourStrongPassword123!" # Change this in production
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aurora-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "aurora-public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "aurora-private-subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aurora-igw"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "aurora-public-rt"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Group for Aurora Cluster
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

# Security Group for RDS Proxy
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

# Secrets Manager for Database Credentials
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

# IAM Policy for RDS Proxy
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
  engine_version        = "5.7.mysql_aurora.2.10.2"
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  db_subnet_group_name  = aws_db_subnet_group.aurora.name
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.aurora.id]
}

# Aurora Instance
resource "aws_rds_cluster_instance" "aurora_instances" {
  count               = 2
  identifier          = "aurora-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.r5.large"
  engine              = aws_rds_cluster.aurora.engine
  engine_version      = aws_rds_cluster.aurora.engine_version
}

# RDS Proxy
resource "aws_db_proxy" "aurora_proxy" {
  name                   = "aurora-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn              = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.proxy.id]
  vpc_subnet_ids         = aws_subnet.private[*].id

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.aurora_credentials.arn
  }
}

# RDS Proxy Target Group
resource "aws_db_proxy_default_target_group" "aurora_target_group" {
  db_proxy_name = aws_db_proxy.aurora_proxy.name

  connection_pool_config {
    max_connections_percent = 100
  }
}

# RDS Proxy Target
resource "aws_db_proxy_target" "aurora_target" {
  db_cluster_identifier = aws_rds_cluster.aurora.id
  db_proxy_name        = aws_db_proxy.aurora_proxy.name
  target_group_name    = aws_db_proxy_default_target_group.aurora_target_group.name
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
</iac_template>

This Terraform configuration creates a complete setup for an Aurora MySQL cluster with RDS Proxy. Here's what the configuration includes:

1. A VPC with two public and two private subnets across different availability zones
2. Internet Gateway and route tables for network connectivity
3. Security groups for both the Aurora cluster and RDS Proxy
4. A Secrets Manager secret to store database credentials
5. IAM role and policy for RDS Proxy to access Secrets Manager
6. An Aurora MySQL cluster with two instances
7. An RDS Proxy configuration with appropriate target group and target
8. All necessary networking components including subnet groups

To use this configuration:

1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: In a production environment, you should:
- Change the default password
- Consider using more secure CIDR blocks for security group rules
- Enable backup retention and other production-grade settings
- Store sensitive variables in a secure manner (e.g., using terraform.tfvars)
- Consider adding additional security measures like encryption at rest