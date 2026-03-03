To fulfill the business need, we will create a Terraform configuration that provisions an AWS EC2 instance and sets up a daily backup plan for it. The configuration will include the following components:

1. **AWS Provider Configuration**: Set up the AWS provider to interact with AWS services in a specified region.
2. **EC2 Key Pair**: Create a key pair to securely access the EC2 instance.
3. **EC2 Instance**: Launch an EC2 instance using the key pair.
4. **IAM Role and Policy**: Create an IAM role and policy to allow AWS Backup to access the EC2 instance.
5. **Backup Vault**: Create a backup vault to store the backups.
6. **Backup Plan**: Define a backup plan with a daily backup rule that triggers at midnight.
7. **Backup Selection**: Associate the EC2 instance with the backup plan.

The following Terraform HCL template implements the above components:

<iac_template>
```hcl
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
```
</iac_template>

This configuration sets up an EC2 instance with a key pair for SSH access, creates a backup vault, and defines a backup plan that runs daily at midnight. The IAM role and policy allow AWS Backup to perform necessary actions on the EC2 instance.