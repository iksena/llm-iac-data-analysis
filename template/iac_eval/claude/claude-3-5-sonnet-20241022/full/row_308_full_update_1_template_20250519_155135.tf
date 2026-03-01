I'll help you create a Terraform configuration that sets up an EC2 instance with daily backups at midnight using AWS Backup service. The configuration will include:

1. AWS provider configuration
2. EC2 instance with a key pair for SSH access
3. AWS Backup vault to store the backups
4. AWS Backup plan configured for daily midnight backups
5. IAM roles and policies for AWS Backup
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

# Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/deployer-key.pub")
}

# EC2 Instance
resource "aws_instance" "main" {
  ami           = "ami-0735c191cf914754d"  # Amazon Linux 2 in us-west-2
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  key_name                   = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  tags = {
    Name = "backup-demo-instance"
  }
}

# AWS Backup
resource "aws_backup_vault" "main" {
  name = "backup-demo-vault"
}

resource "aws_backup_plan" "main" {
  name = "backup-demo-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 0 * * ? *)"  # Daily at midnight

    lifecycle {
      delete_after = 14  # Keep backups for 14 days
    }
  }
}

# IAM Role for AWS Backup
resource "aws_iam_role" "backup" {
  name = "backup-demo-role"

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

resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup.name
}

# AWS Backup Selection
resource "aws_backup_selection" "main" {
  name         = "backup-demo-selection"
  iam_role_arn = aws_iam_role.backup.arn
  plan_id      = aws_backup_plan.main.id

  resources = [
    aws_instance.main.arn
  ]
}
</iac_template>

This Terraform configuration creates:
1. A VPC with a public subnet, internet gateway, and route table
2. A security group allowing SSH access
3. An EC2 key pair (Note: you need to provide the public key file "deployer-key.pub")
4. An EC2 instance running Amazon Linux 2
5. An AWS Backup vault to store backups
6. An AWS Backup plan that runs daily at midnight
7. IAM roles and policies for AWS Backup to perform its operations
8. A backup selection that targets the EC2 instance

To use this configuration:
1. Make sure you have AWS credentials configured
2. Create a "deployer-key.pub" file with your SSH public key in the same directory
3. Run `terraform init` and `terraform apply`

The EC2 instance will be automatically backed up every day at midnight, and backups will be retained for 14 days. The backups are stored in the AWS Backup vault, and you can restore them through the AWS Console or API if needed.