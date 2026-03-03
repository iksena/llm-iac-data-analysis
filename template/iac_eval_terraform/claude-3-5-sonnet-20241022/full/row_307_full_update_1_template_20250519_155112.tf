I'll help you create a Terraform configuration that sets up an EC2 instance with daily backups at midnight using AWS Backup. Here's what the configuration will include:

1. An EC2 instance with Amazon Linux 2
2. AWS Backup vault to store the backups
3. AWS Backup plan with daily schedule at midnight
4. IAM roles and policies for AWS Backup
5. Selection of resources to backup
6. VPC, subnet, and security group for the EC2 instance

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
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
}

# EC2 Instance
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "backup-example-instance"
  }
}

# AWS Backup
resource "aws_backup_vault" "main" {
  name = "example-backup-vault"
}

resource "aws_backup_plan" "main" {
  name = "daily-backup-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 0 * * ? *)"

    lifecycle {
      delete_after = 14
    }
  }
}

# IAM Role for AWS Backup
resource "aws_iam_role" "aws_backup_service_role" {
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

resource "aws_iam_role_policy_attachment" "aws_backup_service_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup_service_role.name
}

# Select resources for backup
resource "aws_backup_selection" "main" {
  name         = "ec2-backup-selection"
  iam_role_arn = aws_iam_role.aws_backup_service_role.arn
  plan_id      = aws_backup_plan.main.id

  resources = [
    aws_instance.main.arn
  ]
}
</iac_template>

This Terraform configuration creates:
1. A VPC with a public subnet, internet gateway, and route table
2. A security group allowing SSH access
3. An EC2 instance running Amazon Linux 2
4. An AWS Backup vault to store backups
5. A backup plan that runs daily at midnight UTC
6. IAM roles and policies for AWS Backup to perform its operations
7. A backup selection that targets the EC2 instance

The backup plan is configured to:
- Run daily at midnight (UTC) using a cron expression
- Keep backups for 14 days before automatically deleting them
- Store backups in a dedicated backup vault

The EC2 instance is:
- Running Amazon Linux 2
- In a public subnet with internet access
- Protected by a security group allowing SSH access
- Tagged for easy identification

To use this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform with `terraform init`
3. Apply the configuration with `terraform apply`

The EC2 instance will be automatically backed up every day at midnight UTC, and the backups will be stored in the AWS Backup vault for 14 days.