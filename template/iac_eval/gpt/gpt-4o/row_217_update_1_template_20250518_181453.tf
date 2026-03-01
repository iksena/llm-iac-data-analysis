provider "aws" {
  region = "us-west-2"
}

resource "aws_db_subnet_group" "default" {
  name       = "my-mysql-subnet-group"
  subnet_ids = ["subnet-abc123", "subnet-def456"] # Replace with your actual subnet IDs

  tags = {
    Name = "MySQL subnet group"
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-security-group"
  description = "Allow MySQL access"
  vpc_id      = "vpc-12345678" # Replace with your actual VPC ID

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust as needed for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySQL security group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "my-mysql-instance"
  allocated_storage       = 100
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  name                    = "mydb"
  username                = "admin"
  password                = "password" # Replace with a secure password
  parameter_group_name    = "default.mysql8.0"
  multi_az                = true
  storage_type            = "gp2"
  vpc_security_group_ids  = [aws_security_group.mysql_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.default.name
  skip_final_snapshot     = true

  tags = {
    Name = "MySQL instance"
  }
}