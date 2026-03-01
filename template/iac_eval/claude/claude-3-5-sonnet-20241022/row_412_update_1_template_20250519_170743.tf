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