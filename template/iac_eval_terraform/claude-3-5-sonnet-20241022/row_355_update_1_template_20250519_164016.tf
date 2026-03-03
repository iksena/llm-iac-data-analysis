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
  default = "mysecretpassword123!"
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
  engine_version        = "5.7.mysql_aurora.2.10.2"
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  db_subnet_group_name  = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora.id]
  skip_final_snapshot   = true
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  depends_on = [aws_db_subnet_group.aurora]
}

# Aurora Instance
resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier         = "aurora-instance-1"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.t3.medium"
  engine            = aws_rds_cluster.aurora.engine
  engine_version    = aws_rds_cluster.aurora.engine_version
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