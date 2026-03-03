provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "airbyte_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.airbyte_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.airbyte_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.airbyte_vpc.id

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

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "airbyte-rds-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

resource "aws_db_instance" "postgres" {
  identifier              = "airbyte-postgres"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.medium"
  allocated_storage       = 500
  name                    = "airbytedb"
  username                = "airbyteuser"
  password                = "securepassword123"
  parameter_group_name    = "default.postgres15"
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot     = true
  backup_retention_period = 7
  auto_minor_version_upgrade = true
}