I'll help you create a Terraform configuration for an AWS RDS Aurora MySQL cluster with a proxy setup. Here's what the configuration will include:

1. VPC with public and private subnets
2. Security groups for the Aurora cluster and proxy
3. RDS Aurora MySQL cluster
4. RDS Proxy configuration
5. Secrets Manager for database credentials
6. Required IAM roles and policies
7. Necessary networking components

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
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

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aurora-igw"
  }
}

# Route Tables
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

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Groups
resource "aws_security_group" "aurora" {
  name        = "aurora-sg"
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
  name        = "aurora-proxy-sg"
  description = "Security group for Aurora proxy"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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

# Secrets Manager
resource "aws_secretsmanager_secret" "aurora_credentials" {
  name = "aurora-credentials"
}

resource "aws_secretsmanager_secret_version" "aurora_credentials" {
  secret_id = aws_secretsmanager_secret.aurora_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "yourpasswordhere123!"
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
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.10.2"
  database_name         = "mydb"
  master_username       = jsondecode(aws_secretsmanager_secret_version.aurora_credentials.secret_string)["username"]
  master_password       = jsondecode(aws_secretsmanager_secret_version.aurora_credentials.secret_string)["password"]
  db_subnet_group_name  = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora.id]
  skip_final_snapshot   = true
}

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

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}
</iac_template>

This Terraform configuration creates a complete setup for an Aurora MySQL cluster with RDS Proxy. Here are the key components:

1. A VPC with two public and two private subnets across different availability zones
2. Security groups for both the Aurora cluster and the RDS Proxy
3. An Aurora MySQL cluster with two instances
4. A Secrets Manager secret to store database credentials
5. An RDS Proxy with the specified idle timeout of 1800 seconds and debug logging disabled
6. Necessary IAM roles and policies for the RDS Proxy to access Secrets Manager
7. Proper networking configuration including route tables and internet gateway

The configuration uses the us-east-1 region and creates a highly available setup across multiple availability zones. The Aurora cluster is placed in private subnets while the proxy manages connections to it. The security groups are configured to allow access to the database only through the proxy.

Remember to:
1. Replace "yourpasswordhere123!" with a strong password
2. Adjust the instance class if needed (currently set to db.r5.large)
3. Modify the CIDR blocks if they conflict with existing networks
4. Consider enabling backup retention and other production-ready features as needed