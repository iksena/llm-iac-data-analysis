terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_database" "mysql_instance" {
  relational_database_name = "my-mysql-database"
  availability_zone       = "us-east-1a"
  master_database_name   = "main_db"
  master_username        = "admin"
  master_password        = "MySuperSecretPassword123!" # Change this in production
  blueprint_id           = "mysql_8_0"
  bundle_id             = "micro_1_0" # Smallest instance size
  
  backup_retention_enabled = true
  preferred_backup_window = "03:00-04:00"
  
  # Configure maintenance window
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  # Enable public accessibility (set to false for private access only)
  publicly_accessible = false

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

output "database_endpoint" {
  value = aws_lightsail_database.mysql_instance.master_endpoint_address
}

output "database_port" {
  value = aws_lightsail_database.mysql_instance.master_endpoint_port
}