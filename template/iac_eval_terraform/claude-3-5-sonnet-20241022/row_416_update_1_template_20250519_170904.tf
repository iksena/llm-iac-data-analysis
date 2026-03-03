provider "aws" {
  region = "us-west-2"
}

# Variables
variable "db_name" {
  description = "Database name"
  default     = "mydb"
}

variable "backup_bucket" {
  description = "S3 bucket containing the backup"
  default     = "my-db-backup-bucket"
}

variable "backup_file" {
  description = "Backup file name in S3"
  default     = "backup.sql"
}

# Create IAM role for RDS
resource "aws_iam_role" "rds_s3_access" {
  name = "rds_s3_access_role"

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

# Create IAM policy for S3 access
resource "aws_iam_role_policy" "rds_s3_policy" {
  name = "rds_s3_policy"
  role = aws_iam_role.rds_s3_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.backup_bucket}",
          "arn:aws:s3:::${var.backup_bucket}/*"
        ]
      }
    ]
  })
}

# Create VPC (if not existing)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create subnets
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "subnet2"
  }
}

# Create DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

# Create security group for RDS
resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "Security group for RDS instance"
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

# Create RDS instance
resource "aws_db_instance" "default" {
  identifier           = "my-restored-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  username            = "admin"
  password            = "password123!" # Change this in production
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  iam_database_authentication_enabled = true
  
  # S3 import configuration
  s3_import {
    source_engine         = "mysql"
    source_engine_version = "8.0"
    bucket_name          = var.backup_bucket
    ingestion_role       = aws_iam_role.rds_s3_access.arn
    bucket_prefix        = var.backup_file
  }
}