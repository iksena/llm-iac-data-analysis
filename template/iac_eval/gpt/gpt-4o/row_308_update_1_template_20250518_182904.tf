provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name

  tags = {
    Name = "MyWebServer"
  }
}

resource "aws_iam_role" "backup_role" {
  name = "BackupRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
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
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_backup_vault" "vault" {
  name = "MyBackupVault"
}

resource "aws_backup_plan" "daily_backup" {
  name = "DailyBackupPlan"

  rule {
    rule_name         = "DailyBackup"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 0 * * ? *)" # Every day at midnight
    lifecycle {
      delete_after = 30
    }
  }
}

resource "aws_backup_selection" "ec2_backup" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "EC2BackupSelection"
  plan_id      = aws_backup_plan.daily_backup.id

  resources = [
    aws_instance.web.arn
  ]
}