provider "aws" {
  region = "us-west-2"
}

resource "random_id" "rds_identifier" {
  byte_length = 8
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}

resource "aws_db_instance" "example" {
  identifier              = random_id.rds_identifier.hex
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "exampledb"
  username                = "admin"
  password                = random_password.rds_password.result
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true

  # VPC security group to allow access
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL access"

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