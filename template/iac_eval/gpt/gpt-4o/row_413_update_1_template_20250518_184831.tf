provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "from_snapshot" {
  identifier              = "my-db-instance"
  snapshot_identifier     = "my-db-snapshot"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = "admin"
  password                = "password1234"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true

  tags = {
    Name = "MyDBInstanceFromSnapshot"
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
  name = "rds-access-policy"
  role = aws_iam_role.rds_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBInstances",
          "rds:CreateDBInstance"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}