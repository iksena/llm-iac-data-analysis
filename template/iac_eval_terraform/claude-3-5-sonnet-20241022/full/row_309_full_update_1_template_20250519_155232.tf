I'll help you create a Terraform configuration that sets up an EC2 instance with daily AWS Backup functionality. This configuration will:
1. Create an EC2 key pair for SSH access
2. Launch an Amazon Linux 2023 EC2 instance
3. Set up AWS Backup vault and plan for daily backups
4. Configure necessary IAM roles and policies
5. Create backup selection to target the EC2 instance

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Key pair resource
resource "aws_key_pair" "server_key" {
  key_name   = "server-key"
  public_key = file("./key.pub")
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# EC2 instance
resource "aws_instance" "server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.server_key.key_name

  tags = {
    Name = "backup-test-server"
  }
}

# AWS Backup vault
resource "aws_backup_vault" "backup_vault" {
  name = "backup-vault"
}

# IAM role for AWS Backup
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

# Attach AWS Backup service role policy
resource "aws_iam_role_policy_attachment" "backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

# AWS Backup plan
resource "aws_backup_plan" "backup_plan" {
  name = "backup-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 0 * * ? *)"

    lifecycle {
      delete_after = 7
    }

    advanced_backup_setting {
      resource_type = "EC2"
      backup_options = {
        WindowsVSS = "disabled"
      }
    }
  }
}

# AWS Backup selection
resource "aws_backup_selection" "backup_selection" {
  name         = "backup-selection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.backup_plan.id

  resources = [
    aws_instance.server.arn
  ]
}
</iac_template>

This configuration creates all the necessary components for backing up an EC2 instance daily. The backup will be stored in a dedicated vault and retained for 7 days. The EC2 instance uses the latest Amazon Linux 2023 AMI and can be accessed using the specified key pair. The backup runs every day at midnight (UTC) and includes all necessary IAM roles and policies for AWS Backup to function properly.

Make sure to have the `key.pub` file in the same directory as your Terraform configuration before applying this template.