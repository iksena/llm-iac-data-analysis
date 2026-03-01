provider "aws" {
  region = "us-east-1"
}

# Variables
variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mypostgresdb"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  default     = "YourStrongPasswordHere123!" # Change this in production
}

# VPC Data Source
data "aws_vpc" "default" {
  default = true
}

# Subnet Data Source
data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "postgres" {
  name        = "postgres-subnet-group"
  description = "Subnet group for Postgres RDS"
  subnet_ids  = data.aws_subnets.available.ids
}

# Security Group
resource "aws_security_group" "postgres" {
  name        = "postgres-sg"
  description = "Security group for Postgres RDS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
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
    Name = "postgres-sg"
  }
}

# RDS Instance
resource "aws_db_instance" "postgres" {
  identifier           = "postgres-db"
  engine              = "postgres"
  engine_version      = "14.7"
  instance_class      = "db.t4g.large"
  allocated_storage   = 20
  storage_type        = "gp2"
  
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]
  
  skip_final_snapshot    = true
  publicly_accessible    = true
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  tags = {
    Name = "postgres-db"
  }
}

# Output
output "db_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.postgres.endpoint
}