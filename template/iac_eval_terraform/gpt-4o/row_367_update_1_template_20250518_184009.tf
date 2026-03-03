provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lightsail_role" {
  name = "lightsail_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lightsail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lightsail_policy" {
  name   = "lightsail_access_policy"
  role   = aws_iam_role.lightsail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lightsail:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lightsail_instance" "mysql_instance" {
  name              = "mysql-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "mysql_5_7"
  bundle_id         = "micro_2_0"

  tags = {
    Name = "MySQLInstance"
  }
}

output "instance_name" {
  value = aws_lightsail_instance.mysql_instance.name
}

output "instance_arn" {
  value = aws_lightsail_instance.mysql_instance.arn
}