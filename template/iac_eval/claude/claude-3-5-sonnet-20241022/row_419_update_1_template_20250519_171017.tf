provider "aws" {
  region = "us-east-1"
}

# Random string for password generation
resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# KMS key for encryption
resource "aws_kms_key" "rds_encryption_key" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  
  tags = {
    Name = "rds-encryption-key"
  }
}

resource "aws_kms_alias" "rds_encryption_key_alias" {
  name          = "alias/rds-encryption-key"
  target_key_id = aws_kms_key.rds_encryption_key.key_id
}

# Secrets Manager secret
resource "aws_secretsmanager_secret" "rds_secret" {
  name                    = "rds-master-password"
  kms_key_id             = aws_kms_key.rds_encryption_key.arn
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.master_password.result
  })
}

# VPC (using default for this example)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = data.aws_vpc.default.id

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

  tags = {
    Name = "rds-security-group"
  }
}

# RDS Instance
resource "aws_db_instance" "database" {
  identifier           = "my-rds-instance"
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]
  password            = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  storage_encrypted = true
  kms_key_id       = aws_kms_key.rds_encryption_key.arn

  tags = {
    Name = "my-rds-instance"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "My DB subnet group"
  }
}

# Output the secret ARN
output "secret_arn" {
  value = aws_secretsmanager_secret.rds_secret.arn
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.database.endpoint
}