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
  master_database_name   = "maindb"
  master_username       = "dbadmin"
  master_password       = "Password123!" # Change this in production

  blueprint_id          = "mysql_8_0"
  bundle_id            = "micro_2_0"
  skip_final_snapshot  = true

  backup_retention_enabled = true
  preferred_backup_window = "03:00-04:00"
  preferred_maintenance_window = "sun:05:00-sun:06:00"
}

output "database_endpoint" {
  description = "Database endpoint address"
  value       = aws_lightsail_database.mysql_db.master_endpoint_address
}

output "database_port" {
  description = "Database port"
  value       = aws_lightsail_database.mysql_db.master_port
}