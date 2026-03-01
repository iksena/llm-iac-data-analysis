I'll help you create an Amazon RDS SQL database instance with a read replica using Terraform. This configuration will:

1. Create a primary RDS instance (MySQL)
2. Create a read replica of the primary instance
3. Set up necessary security groups
4. Configure appropriate subnet groups
5. Use default VPC and its subnets

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create DB subnet group
resource "aws_db_subnet_group" "default" {
  name        = "main-subnet-group"
  description = "Main DB subnet group"
  subnet_ids  = data.aws_subnets.default.ids
}

# Create security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instances"
  vpc_id      = data.aws_vpc.default.id

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

  tags = {
    Name = "rds-security-group"
  }
}

# Create primary RDS instance
resource "aws_db_instance" "primary" {
  identifier           = "primary-database"
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0.28"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password123!" # Change this in production
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "primary-database"
  }
}

# Create read replica
resource "aws_db_instance" "replica" {
  identifier           = "replica-database"
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  tags = {
    Name = "replica-database"
  }
}

# Output the endpoints
output "primary_endpoint" {
  value = aws_db_instance.primary.endpoint
}

output "replica_endpoint" {
  value = aws_db_instance.replica.endpoint
}
</iac_template>

This Terraform configuration creates:

1. A primary MySQL RDS instance with:
   - 20GB GP2 storage
   - MySQL 8.0.28
   - db.t3.micro instance type
   - Basic security settings

2. A read replica of the primary instance with:
   - Same instance type as primary
   - Automatic replication configuration
   - Same security group as primary

3. Supporting resources:
   - DB subnet group using the default VPC's subnets
   - Security group allowing MySQL access (port 3306)
   - Necessary networking configurations

4. Outputs:
   - Endpoints for both primary and replica instances

Important notes:
1. This uses the default VPC and its subnets
2. The password is hardcoded (change this in production)
3. Skip_final_snapshot is set to true (you might want to change this in production)
4. Security group allows access from anywhere (0.0.0.0/0) - restrict this in production

To use this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

Remember to change the password and tighten security settings for production use.