The Terraform program will create an AWS EC2 key pair using a public key from a specified file. It will then launch an EC2 instance using the Amazon Linux 2023 x86-64 AMI and associate it with the created key pair. Additionally, the program will set up an AWS Backup plan with a rule to back up the EC2 instance daily at midnight, storing the backups in a specified backup vault. The backup plan will have a lifecycle policy to delete backups after 7 days. An IAM role will be created for the backup selection, with the necessary policy attached to allow AWS Backup to perform backups.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("./key.pub")
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name
}

resource "aws_backup_vault" "my_backup_vault" {
  name = "my-backup-vault"
}

resource "aws_backup_plan" "my_backup_plan" {
  name = "my-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.my_backup_vault.name
    schedule          = "cron(0 0 * * ? *)"

    lifecycle {
      delete_after = 7
    }

    advanced_backup_setting {
      resource_type = "EC2"
    }
  }
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

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_selection" "my_backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "my-backup-selection"
  plan_id      = aws_backup_plan.my_backup_plan.id

  resources = [
    aws_instance.my_instance.arn
  ]
}
```
</iac_template>