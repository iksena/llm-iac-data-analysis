provider "aws" {
  region = "us-east-1"
}

# Random password generator
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-mysql-sg"
  description = "Security group for RDS MySQL instance"

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
    Name = "rds-mysql-sg"
  }
}

# RDS Instance
resource "aws_db_instance" "mysql_instance" {
  identifier           = "mysql-database"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t3.micro"
  allocated_storage   = 200
  storage_type        = "gp2"
  
  username            = "admin"
  password            = random_password.db_password.result
  
  publicly_accessible = true
  skip_final_snapshot = true
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "mysql-database"
  }

  # Parameter group
  parameter_group_name = "default.mysql5.7"
}

# Output the database endpoint and generated password
output "database_endpoint" {
  value = aws_db_instance.mysql_instance.endpoint
}

output "database_password" {
  value     = random_password.db_password.result
  sensitive = true
}