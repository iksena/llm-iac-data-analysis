provider "aws" {
  region = "us-west-2"
}

# Variables
variable "vpc_id" {
  description = "VPC ID where the DB will be deployed"
  default     = "vpc-12345678" # Replace with your VPC ID
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"] # Replace with your subnet IDs
}

variable "snapshot_identifier" {
  description = "Snapshot identifier for the source snapshot"
  default     = "my-database-snapshot" # Replace with your snapshot identifier
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "main-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Main DB subnet group"
  }
}

# Create Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Replace with your desired CIDR block
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

# Create RDS Instance from snapshot
resource "aws_db_instance" "default" {
  identifier           = "my-restored-db"
  snapshot_identifier  = var.snapshot_identifier
  instance_class      = var.db_instance_class
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  # These parameters are required even when restoring from snapshot
  engine                  = "mysql"  # Must match the engine of the snapshot
  skip_final_snapshot    = true
  
  # Additional optional parameters
  multi_az             = false
  publicly_accessible  = false
  
  tags = {
    Name = "Restored RDS Instance"
    Environment = "Production"
  }
}

# Output the endpoint of the restored database
output "db_endpoint" {
  value = aws_db_instance.default.endpoint
}