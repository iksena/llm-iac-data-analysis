provider "aws" {
  region = "us-west-2"
}

# Variables
variable "db_instance_identifier" {
  description = "Identifier for the RDS instance"
  default     = "my-mysql-instance"
}

variable "db_name" {
  description = "Name of the database"
  default     = "mydb"
}

variable "db_username" {
  description = "Username for the database"
  default     = "admin"
}

variable "db_password" {
  description = "Password for the database"
  default     = "mypassword123!" # Change this in production
}

# VPC Data Source (assumes default VPC)
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
  description = "Security group for RDS MySQL instance"
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

# DB Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "My DB subnet group"
  }
}

# RDS Instance
resource "aws_db_instance" "mysql" {
  identifier           = var.db_instance_identifier
  engine              = "mysql"
  engine_version      = "8.0.28"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  username            = var.db_username
  password            = var.db_password
  db_name             = var.db_name
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "MySQL Instance"
  }
}

# RDS Snapshot
resource "aws_db_snapshot" "mysql_snapshot" {
  db_instance_identifier = aws_db_instance.mysql.id
  db_snapshot_identifier = "${var.db_instance_identifier}-snapshot"
}