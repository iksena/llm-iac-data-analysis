I'll help you create a Terraform configuration to provision a secure PostgreSQL RDS instance with the specified requirements. Here's what the configuration will include:

1. VPC with public and private subnets across multiple availability zones
2. RDS subnet group using private subnets
3. Security group for RDS access
4. KMS key for database encryption
5. PostgreSQL parameter group
6. RDS instance with PostgreSQL 15, 50GB storage, and Multi-AZ deployment

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
    Name = "postgresql-vpc"
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
resource "aws_db_subnet_group" "postgresql" {
  name       = "postgresql-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

# Security Group
resource "aws_security_group" "postgresql" {
  name        = "postgresql-sg"
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
resource "aws_kms_key" "postgresql" {
  description             = "KMS key for PostgreSQL RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "postgresql" {
  name          = "alias/postgresql-key"
  target_key_id = aws_kms_key.postgresql.key_id
}

# Parameter Group
resource "aws_db_parameter_group" "postgresql" {
  family = "postgres15"
  name   = "postgresql-params"

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "shared_buffers"
    value = "16384"
  }
}

# RDS Instance
resource "aws_db_instance" "postgresql" {
  identifier        = "postgresql-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.medium"
  allocated_storage = 50

  db_name  = "mydb"
  username = "dbadmin"
  password = "YourSecurePassword123!" # In production, use AWS Secrets Manager

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.postgresql.name
  vpc_security_group_ids = [aws_security_group.postgresql.id]
  parameter_group_name   = aws_db_parameter_group.postgresql.name

  storage_encrypted = true
  kms_key_id       = aws_kms_key.postgresql.arn

  backup_retention_period = 7
  skip_final_snapshot    = true

  tags = {
    Name = "postgresql-instance"
  }
}
</iac_template>

This Terraform configuration creates a secure PostgreSQL RDS instance with the following features:

1. Creates a VPC with two private subnets in different availability zones
2. Sets up a DB subnet group for the RDS instance
3. Creates a security group allowing PostgreSQL traffic (port 5432) only from within the VPC
4. Provisions a KMS key for database encryption
5. Configures a custom parameter group with specific PostgreSQL settings
6. Deploys a Multi-AZ PostgreSQL 15 RDS instance with:
   - 50GB storage
   - Encryption enabled using the KMS key
   - Automated backups with 7-day retention
   - Custom parameter group applied
   - Security group restrictions
   - Placed in private subnets

Note: In a production environment, you should:
1. Use AWS Secrets Manager for database credentials
2. Adjust the security group rules according to your specific needs
3. Configure additional parameters in the parameter group as required
4. Consider using variables for customizable values
5. Add additional networking components like Internet Gateway, NAT Gateway, and route tables if needed