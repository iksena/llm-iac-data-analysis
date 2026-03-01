The Terraform program will provision a secure PostgreSQL database instance within a specified AWS VPC using Amazon RDS. It will utilize AWS services such as subnets and KMS for encryption. The configuration will include a custom parameter group for PostgreSQL settings and a security group to manage access. The database instance will be configured with the following specifications: instance class "db.t3.micro", storage size, engine version, multi-AZ deployment for high availability, and encryption using a KMS key. Additionally, the backup retention period will be set to 7 days.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
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

resource "aws_kms_key" "rds" {
  description = "KMS key for RDS encryption"
}

resource "aws_db_parameter_group" "postgresql" {
  name   = "custom-postgresql"
  family = "postgres13"

  parameter {
    name  = "max_connections"
    value = "100"
  }
}

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = aws_db_parameter_group.postgresql.name
  multi_az             = true
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds.arn
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  backup_retention_period = 7
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.main.id, aws_subnet.secondary.id]
}
```
</iac_template>