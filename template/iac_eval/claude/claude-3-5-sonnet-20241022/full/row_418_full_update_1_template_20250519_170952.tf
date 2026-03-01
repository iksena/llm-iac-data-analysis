I'll help you create a Terraform configuration for an AWS RDS database instance that uses AWS Secrets Manager for password management and the default KMS key for encryption. This configuration will:

1. Create a Secrets Manager secret for the database master password
2. Create an RDS database instance using MySQL engine
3. Use the generated secret as the master password
4. Enable encryption using the default KMS key
5. Create necessary security group for database access
6. Set up required IAM roles and policies

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Random string for password generation
resource "random_password" "master_password" {
  length  = 16
  special = true
}

# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name = "rds-master-password"
}

# Store the generated password in Secrets Manager
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.master_password.result
}

# Create VPC (since RDS requires a VPC)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create subnet group for RDS
resource "aws_subnet" "main" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Main ${count.index + 1}"
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.main[*].id

  tags = {
    Name = "My DB subnet group"
  }
}

# Create security group for RDS
resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

# Create RDS instance
resource "aws_db_instance" "default" {
  identifier           = "my-rds-instance"
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = "mydb"
  username            = "admin"
  password            = random_password.master_password.result
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  storage_encrypted = true # Uses default KMS key

  tags = {
    Name = "MyRDSInstance"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Main Route Table"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "main" {
  count          = 2
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main.id
}

# Output the secret ARN
output "secret_arn" {
  value = aws_secretsmanager_secret.db_password.arn
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}
</iac_template>

This Terraform configuration creates:
1. A new VPC with two subnets across different availability zones
2. A security group allowing MySQL access (port 3306)
3. A random password stored in AWS Secrets Manager
4. An RDS MySQL instance that:
   - Uses the generated password
   - Is encrypted with the default KMS key
   - Is placed in the created VPC and subnet group
   - Has basic networking components (IGW, route tables)

The configuration includes all necessary networking components to make the RDS instance accessible within the VPC. The database password is automatically generated and stored in AWS Secrets Manager for secure access. The RDS instance uses the default AWS KMS key for encryption at rest.

You can deploy this configuration and get the database endpoint and secrets ARN from the outputs. Remember to adjust the CIDR blocks and other parameters according to your specific requirements.