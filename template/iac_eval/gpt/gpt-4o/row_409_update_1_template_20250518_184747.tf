provider "aws" {
  region = "us-west-2"
}

resource "aws_db_subnet_group" "default" {
  name       = "default"
  subnet_ids = ["subnet-abc123", "subnet-def456"] # Replace with your actual subnet IDs

  tags = {
    Name = "Default subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow PostgreSQL access"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with more restrictive CIDR blocks in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "memory-optimized-postgres"
  engine                  = "postgres"
  instance_class          = "db.r5.large" # Memory optimized instance type
  allocated_storage       = 20
  name                    = "mydatabase"
  username                = "admin"
  password                = "securepassword" # Replace with a secure password
  parameter_group_name    = "default.postgres12"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true

  tags = {
    Name = "Memory Optimized PostgreSQL"
  }
}