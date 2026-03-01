provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "my_mysql_instance" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  # Optional: Define a subnet group if needed
  # db_subnet_group_name = "my-subnet-group"

  # Optional: Define security group if needed
  # vpc_security_group_ids = ["sg-12345678"]

  tags = {
    Name = "MySQLInstance"
  }
}

resource "aws_iam_role" "rds_access_role" {
  name = "rds-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "rds_access_policy" {
  name   = "rds-access-policy"
  role   = aws_iam_role.rds_access_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}