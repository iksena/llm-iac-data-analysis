terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

resource "aws_lightsail_database" "mysql_db" {
  relational_database_name = "my-mysql-database"
  availability_zone       = "us-east-1a"  # Must be in the same region as provider
  master_database_name   = "main_db"
  master_username       = "admin"
  master_password       = "MySuperSecretPassword123!"  # Change this in production
  blueprint_id          = "mysql_8_0"
  bundle_id            = "micro_1_0"  # Smallest instance size, adjust as needed
  
  preferred_backup_window      = "16:00-16:30"
  preferred_maintenance_window = "tue:17:00-tue:17:30"
  
  backup_retention_enabled = true
  
  # Configure other database parameters
  parameter {
    apply_method = "pending-reboot"
    name         = "character_set_server"
    value        = "utf8"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "collation_server"
    value        = "utf8_general_ci"
  }

  # Basic database configuration
  storage_type          = "ssd"
  storage_gb           = 40

  # Enable public accessibility (set to false if you want private only)
  public_access        = true

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Output the database endpoint
output "database_endpoint" {
  value = aws_lightsail_database.mysql_db.master_endpoint_address
}

output "database_port" {
  value = aws_lightsail_database.mysql_db.master_endpoint_port
}