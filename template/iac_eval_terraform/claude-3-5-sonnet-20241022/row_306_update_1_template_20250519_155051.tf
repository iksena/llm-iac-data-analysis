provider "aws" {
  region = "us-east-1"
}

# VPC and Subnet data sources (assuming default VPC)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
  default_for_az    = true
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-backup-demo-sg"
  description = "Security group for EC2 backup demo"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-backup-demo-sg"
  }
}

# EC2 Instance
resource "aws_instance" "demo_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.default.id

  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "backup-demo-instance"
  }
}

# AWS Backup vault
resource "aws_backup_vault" "backup_vault" {
  name = "demo-backup-vault"
}

# IAM role for AWS Backup
resource "aws_iam_role" "backup_role" {
  name = "aws-backup-service-role"

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
  name = "daily-backup-plan"

  rule {
    rule_name         = "daily_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 0 * * ? *)" # Run at midnight every day

    lifecycle {
      delete_after = 30 # Keep backups for 30 days
    }
  }
}

# AWS Backup selection
resource "aws_backup_selection" "backup_selection" {
  name         = "ec2-backup-selection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.backup_plan.id

  resources = [
    aws_instance.demo_instance.arn
  ]
}