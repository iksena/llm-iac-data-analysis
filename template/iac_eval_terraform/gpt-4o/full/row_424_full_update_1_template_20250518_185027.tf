To fulfill the business need, we will create an AWS Elastic File System (EFS) with automatic backups enabled. This involves setting up an EFS file system and configuring it to automatically create backups using AWS Backup. We will define the necessary IAM roles and policies to allow AWS Backup to manage the EFS backups. The configuration will be deployed in the `us-east-1` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_efs_file_system" "example" {
  creation_token = "example-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "example-efs"
  }
}

resource "aws_backup_vault" "example" {
  name        = "example-backup-vault"
  tags = {
    Name = "example-backup-vault"
  }
}

resource "aws_backup_plan" "example" {
  name = "example-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.example.name

    schedule = "cron(0 12 * * ? *)" # Daily at 12:00 UTC

    lifecycle {
      delete_after = 30
    }
  }
}

resource "aws_backup_selection" "example" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "example-backup-selection"
  plan_id      = aws_backup_plan.example.id

  resources = [
    aws_efs_file_system.example.arn
  ]
}

resource "aws_iam_role" "backup_role" {
  name = "backup-role"

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

resource "aws_iam_policy" "backup_policy" {
  name        = "backup-policy"
  description = "Policy for AWS Backup to access EFS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeTags"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "backup:StartBackupJob",
          "backup:ListBackupJobs",
          "backup:GetBackupVaultAccessPolicy"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = aws_iam_role.backup_role.name
  policy_arn = aws_iam_policy.backup_policy.arn
}
```
</iac_template>