I'll help you create a Terraform configuration to provision a secure PostgreSQL RDS instance with all the necessary components. Here's what the configuration will include:

1. VPC with public and private subnets
2. RDS subnet group using private subnets
3. Security group for RDS access
4. KMS key for encryption
5. PostgreSQL parameter group
6. RDS instance with specified configurations
7. Necessary IAM roles and policies

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
    Name = "postgres-vpc"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private-subnet-2"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

# Security Group
resource "aws_security_group" "postgres" {
  name        = "postgres-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# KMS Key
resource "aws_kms_key" "postgres" {
  description             = "KMS key for PostgreSQL RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "postgres" {
  name          = "alias/postgres-kms-key"
  target_key_id = aws_kms_key.postgres.key_id
}

# PostgreSQL Parameter Group
resource "aws_db_parameter_group" "postgres" {
  family = "postgres14"
  name   = "custom-postgres14-params"

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "shared_buffers"
    value = "{DBInstanceClassMemory/32768}"
  }
}

# RDS Instance
resource "aws_db_instance" "postgres" {
  identifier        = "postgres-db"
  engine            = "postgres"
  engine_version    = "14.7"
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "mydb"
  username = "dbadmin"
  password = "YourSecurePassword123!" # In production, use AWS Secrets Manager

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]
  parameter_group_name   = aws_db_parameter_group.postgres.name

  storage_encrypted = true
  kms_key_id       = aws_kms_key.postgres.arn

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  skip_final_snapshot = true

  tags = {
    Name = "PostgreSQL RDS Instance"
  }
}

# Output the database endpoint
output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
</iac_template>

This Terraform configuration creates a secure PostgreSQL RDS instance with the following features:

1. Creates a VPC with two private subnets in different availability zones
2. Sets up a DB subnet group for the RDS instance
3. Creates a security group that allows PostgreSQL traffic (port 5432) only from within the VPC
4. Provisions a KMS key for encryption at rest
5. Configures a custom parameter group with optimized settings
6. Deploys a Multi-AZ PostgreSQL RDS instance with:
   - PostgreSQL 14.7
   - 20GB GP2 storage
   - db.t3.medium instance type
   - Automated backups with 7-day retention
   - Encryption at rest using KMS
   - Custom maintenance and backup windows
   - Custom parameter group settings

Note: In a production environment, you should:
1. Store the database password in AWS Secrets Manager or use SSM Parameter Store
2. Add more security group rules based on your specific needs
3. Configure additional networking components like Internet Gateway, NAT Gateway, and route tables
4. Adjust the instance size and storage based on your workload
5. Consider using variables for customization
6. Implement proper tagging strategy

The configuration outputs the database endpoint which can be used by applications to connect to the database.