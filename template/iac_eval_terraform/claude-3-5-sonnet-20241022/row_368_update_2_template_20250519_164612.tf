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

resource "aws_lightsail_database" "mysql_db" {
  relational_database_name = "my-mysql-db"
  availability_zone       = "us-east-1a"
  blueprint_id           = "mysql_8_0"
  bundle_id             = "db_micro_1_0"
  master_database_name  = "maindb"
  master_username      = "dbadmin"
  master_password      = "MySecurePassword123!"

  preferred_backup_window      = "16:00-16:30"
  preferred_maintenance_window = "tue:17:00-tue:17:30"
  backup_retention_enabled    = true

  tags = {
    Name        = "mysql-lightsail-db"
    Environment = "Production"
  }
}

output "database_endpoint" {
  description = "Database endpoint address"
  value       = aws_lightsail_database.mysql_db.master_endpoint_address
}

output "database_port" {
  description = "Database port"
  value       = aws_lightsail_database.mysql_db.master_endpoint_port
}