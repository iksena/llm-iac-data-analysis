provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Database Instance
resource "aws_lightsail_database" "mysql_database" {
  relational_database_name = "my-mysql-database"
  availability_zone       = "us-east-1a"
  master_database_name   = "main_db"
  master_username        = "admin"
  master_password        = "MyP@ssw0rd123!" # Change this in production
  blueprint_id           = "mysql_8_0"
  bundle_id             = "micro_1_0"
  
  # Configure backup retention
  backup_retention_enabled = true
  
  # Configure backup window
  preferred_backup_window = "03:00-04:00"
  
  # Configure maintenance window
  preferred_maintenance_window = "sun:05:00-sun:06:00"
  
  # Configure public accessibility
  publicly_accessible = false
  
  # Configure storage
  storage_gb = 40

  # Enable high availability
  apply_immediately = true

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Output the database endpoint
output "database_endpoint" {
  value = aws_lightsail_database.mysql_database.master_endpoint_address
}

# Output the database username
output "database_username" {
  value = aws_lightsail_database.mysql_database.master_username
}

# Output the database port
output "database_port" {
  value = aws_lightsail_database.mysql_database.master_port
}