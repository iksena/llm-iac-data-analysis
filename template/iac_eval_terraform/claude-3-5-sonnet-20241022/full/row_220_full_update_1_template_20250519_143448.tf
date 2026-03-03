I'll help you create a PostgreSQL instance using AWS RDS (Relational Database Service) with Terraform. This configuration will:

1. Create a VPC with public and private subnets
2. Set up necessary security groups
3. Create an RDS PostgreSQL instance in the private subnet
4. Configure basic database parameters and security settings

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  default     = "dbpassword123!" # Change this in production
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "postgresql-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "postgresql-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "postgresql-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "postgresql-igw"
  }
}

# Security Group for PostgreSQL
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

  tags = {
    Name = "postgresql-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "postgresql" {
  name       = "postgresql-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgresql" {
  identifier           = "postgresql-instance"
  engine              = "postgres"
  engine_version      = "13.7"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.postgresql.id]
  db_subnet_group_name   = aws_db_subnet_group.postgresql.name

  backup_retention_period = 7
  multi_az               = false
  publicly_accessible    = false

  tags = {
    Name = "postgresql-instance"
  }
}

# Output the endpoint
output "postgresql_endpoint" {
  value = aws_db_instance.postgresql.endpoint
}
</iac_template>

This Terraform configuration creates:

1. A VPC with public and private subnets
2. Security group allowing PostgreSQL traffic (port 5432) within the VPC
3. DB subnet group spanning multiple availability zones
4. PostgreSQL RDS instance with the following specifications:
   - Engine: PostgreSQL 13.7
   - Instance Class: db.t3.micro
   - Storage: 20GB GP2
   - Backup retention: 7 days
   - Multi-AZ: Disabled (for cost savings, enable for production)
   - Publicly accessible: No (for security)

To deploy this configuration:

1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: For production use, you should:
- Change the default database password
- Consider enabling Multi-AZ deployment
- Adjust the instance class based on your needs
- Implement more strict security group rules
- Use AWS Secrets Manager for credential management
- Consider enabling encryption at rest

The configuration will output the PostgreSQL endpoint which you can use to connect to your database.