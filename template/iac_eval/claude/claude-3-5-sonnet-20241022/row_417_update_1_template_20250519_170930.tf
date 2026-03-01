provider "aws" {
  region = "us-west-2"
}

# Variables
variable "vpc_id" {
  description = "VPC ID where the DB will be deployed"
  default     = "vpc-12345678" # Replace with your VPC ID
}

variable "subnet_ids" {
  description = "Subnet IDs for the DB subnet group"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"] # Replace with your subnet IDs
}

# Create DB subnet group
resource "aws_db_subnet_group" "main" {
  name        = "main-db-subnet-group"
  description = "DB subnet group for RDS"
  subnet_ids  = var.subnet_ids
}

# Create security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

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

# Create RDS instance with autoscaling
resource "aws_db_instance" "main" {
  identifier        = "my-rds-instance"
  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  
  # Storage autoscaling configuration
  max_allocated_storage = 100
  
  # Database credentials
  username = "admin"
  password = "password123!" # Change this in production

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  # Additional configuration
  publicly_accessible    = false
  skip_final_snapshot   = true
  
  tags = {
    Name = "autoscaling-enabled-rds"
  }
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}