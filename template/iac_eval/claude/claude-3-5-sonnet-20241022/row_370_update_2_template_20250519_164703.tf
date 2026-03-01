terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "random" {
}

resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_lightsail_database" "postgres_db" {
  relational_database_name = "my-postgres-db"
  availability_zone        = "us-east-1a"
  master_database_name    = "maindb"
  master_username         = "dbadmin"
  master_password         = random_password.master_password.result
  blueprint_id            = "postgres_12"
  bundle_id              = "micro_2_0"
  apply_immediately      = true

  backup_retention_enabled      = true
  preferred_backup_window      = "03:00-04:00"
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

output "database_endpoint" {
  description = "Database endpoint address"
  value       = aws_lightsail_database.postgres_db.master_endpoint_address
}

output "database_username" {
  description = "Database master username"
  value       = aws_lightsail_database.postgres_db.master_username
}

output "database_password" {
  description = "Database master password"
  value       = random_password.master_password.result
  sensitive   = true
}