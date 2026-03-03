provider "aws" {
  region = "us-east-1"
}

# Create random password for database
resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create Lightsail Database
resource "aws_lightsail_database" "postgres_db" {
  relational_database_name = "my-postgres-db"
  availability_zone       = "us-east-1a"
  master_database_name   = "main"
  master_username       = "dbadmin"
  master_password      = random_password.master_password.result
  blueprint_id         = "postgres_12"
  bundle_id           = "micro_2_0"
  skip_final_snapshot = false
  final_snapshot_name = "final-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"

  # Configure backup
  backup_retention_enabled = true
  preferred_backup_window = "03:00-04:00"

  # Configure maintenance window
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Output the database endpoint
output "database_endpoint" {
  value = aws_lightsail_database.postgres_db.master_endpoint_address
}

# Output the master username
output "master_username" {
  value = aws_lightsail_database.postgres_db.master_username
}

# Output the generated password
output "master_password" {
  value     = random_password.master_password.result
  sensitive = true
}