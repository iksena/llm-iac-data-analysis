provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "db_subnet" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

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
}

resource "aws_kms_key" "rds_key" {
  description = "KMS key for RDS encryption"
}

resource "aws_db_parameter_group" "postgresql" {
  name        = "custom-postgresql"
  family      = "postgres13"
  description = "Custom parameter group for PostgreSQL"

  parameter {
    name  = "max_connections"
    value = "100"
  }
}

resource "aws_db_instance" "postgresql" {
  identifier              = "my-postgresql-db"
  engine                  = "postgres"
  engine_version          = "13.4"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  multi_az                = true
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.rds_key.arn
  parameter_group_name    = aws_db_parameter_group.postgresql.name
  username                = "admin"
  password                = "securepassword123"
  skip_final_snapshot     = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = aws_subnet.db_subnet[*].id
}