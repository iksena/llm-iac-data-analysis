provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "backup_role" {
  name = "BackupServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
        Action = "sts:AssumeRole"
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
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_backup_vault" "my_backup_vault" {
  name = "MyBackupVault"
}

resource "aws_backup_plan" "daily_backup" {
  name = "DailyBackupPlan"

  rule {
    rule_name         = "DailyBackup"
    target_vault_name = aws_backup_vault.my_backup_vault.name
    schedule          = "cron(0 0 * * ? *)" # Every day at midnight
    lifecycle {
      delete_after = 30 # Retain backups for 30 days
    }
  }
}

resource "aws_backup_selection" "ec2_backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "EC2BackupSelection"
  plan_id      = aws_backup_plan.daily_backup.id

  resources = [
    aws_instance.web.arn
  ]
}