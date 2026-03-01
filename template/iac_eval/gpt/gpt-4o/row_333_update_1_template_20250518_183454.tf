provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "rds_encryption" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 10
}

resource "aws_db_parameter_group" "postgresql_parameters" {
  name   = "custom-postgresql-parameters"
  family = "postgres13"

  parameter {
    name  = "max_connections"
    value = "100"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"

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

resource "aws_db_instance" "postgresql" {
  identifier              = "my-postgresql-db"
  engine                  = "postgres"
  engine_version          = "13.4"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.rds_encryption.arn
  db_subnet_group_name    = "my-db-subnet-group" # Assumes existing subnet group
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = true
  username                = "admin"
  password                = "securepassword123"
  parameter_group_name    = aws_db_parameter_group.postgresql_parameters.name
  skip_final_snapshot     = false
  final_snapshot_identifier = "pgsnapshot"
}