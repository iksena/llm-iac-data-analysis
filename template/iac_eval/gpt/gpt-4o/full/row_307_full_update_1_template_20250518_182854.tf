To fulfill the business need, we will create a Terraform configuration that provisions an AWS EC2 instance and sets up a daily backup plan using AWS Backup. The configuration will include the necessary IAM roles and policies to allow AWS Backup to manage the backup of the EC2 instance. We will use the AWS provider and specify a region for deployment. The EC2 instance will be created with a default Amazon Machine Image (AMI) and instance type. The backup plan will be configured to run daily at midnight.

<iac_template>
```hcl
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
```
</iac_template>