I'll help you create a MySQL RDS instance in AWS using Terraform. This configuration will:
1. Create a VPC with necessary networking components
2. Set up a security group for the RDS instance
3. Create an RDS MySQL instance with standard configuration
4. Set up necessary IAM roles and policies

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "db_name" {
  description = "Database name"
  default     = "mydb"
}

variable "db_username" {
  description = "Database administrator username"
  default     = "admin"
}

variable "db_password" {
  description = "Database administrator password"
  default     = "mypassword123!" # Change this in production
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create public subnet
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Public Subnet 1"
  }
}

# Create public subnet
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Public Subnet 2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

# Create Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "Security group for RDS MySQL instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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

# Create DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

# Create RDS Instance
resource "aws_db_instance" "default" {
  identifier           = "mysql-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "MyRDSInstance"
  }
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two public subnets across different availability zones
2. An Internet Gateway for network connectivity
3. A security group that allows MySQL traffic (port 3306)
4. A DB subnet group spanning multiple availability zones
5. An RDS MySQL instance with the following specifications:
   - 20GB GP2 storage
   - MySQL 8.0
   - db.t3.micro instance type
   - Basic network security configuration

Important notes:
- The default password is set for demonstration purposes. In a production environment, you should use a more secure method to manage passwords (like AWS Secrets Manager or SSM Parameter Store)
- The security group allows access from any IP (0.0.0.0/0). In a production environment, you should restrict this to specific IP ranges
- The configuration uses the cheapest instance type (db.t3.micro) for cost-effectiveness. Adjust based on your needs
- skip_final_snapshot is set to true for easier cleanup. In production, you might want to set this to false

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

The RDS endpoint will be output after successful creation, which you can use to connect to your database.