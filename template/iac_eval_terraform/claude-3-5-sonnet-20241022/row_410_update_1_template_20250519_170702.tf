provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "db_instance_identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "my-mysql-instance"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  default     = "mypassword123!" # Change this in production
}

# Create VPC Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS MySQL instance"

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

# Create RDS Instance
resource "aws_db_instance" "mysql" {
  identifier           = var.db_instance_identifier
  engine              = "mysql"
  engine_version      = "8.0.28"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  
  apply_immediately   = true  # This ensures changes are applied immediately
  skip_final_snapshot = true  # Skip final snapshot when destroying
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  
  tags = {
    Name = "MySQL RDS Instance"
    Environment = "Development"
  }
}

# Output the endpoint
output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}