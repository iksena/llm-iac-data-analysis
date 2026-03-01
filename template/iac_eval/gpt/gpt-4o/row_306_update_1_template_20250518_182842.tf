provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
}

resource "aws_iam_role" "backup_role" {
  name = "BackupServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "backup_policy" {
  name   = "BackupPolicy"
  role   = aws_iam_role.backup_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_backup_vault" "example" {
  name = "example_backup_vault"
}

resource "aws_backup_plan" "example" {
  name = "example_backup_plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.example.name
    schedule          = "cron(0 0 * * ? *)" # Every day at midnight UTC
    lifecycle {
      delete_after = 30 # Retain backups for 30 days
    }
  }
}

resource "aws_backup_selection" "example" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "example_backup_selection"
  plan_id      = aws_backup_plan.example.id

  resources = [
    aws_instance.example.arn
  ]
}