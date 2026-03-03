I'll help you create a Terraform configuration for an AWS Lightsail PostgreSQL database instance with final snapshot enabled. This configuration will:

1. Set up the AWS provider
2. Create a Lightsail PostgreSQL database instance
3. Enable final snapshot creation when the database is deleted
4. Configure basic database parameters like master username and password
5. Set up backup and maintenance windows

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Creates a random password generator for the database master password
3. Creates a Lightsail PostgreSQL database with:
   - PostgreSQL 12 as the database engine
   - Micro bundle (2 vCPUs, 2GB RAM)
   - Automatic backups enabled with a retention window
   - Weekly maintenance window on Sundays
   - Final snapshot enabled (created when the database is deleted)
   - Custom tags for better resource management
4. Outputs important information like:
   - Database endpoint
   - Master username
   - Generated password (marked as sensitive)

The configuration ensures that:
- A final snapshot is created when the database is deleted (skip_final_snapshot = false)
- The final snapshot name includes a timestamp to make it unique
- Backups are enabled and retained
- The database has a secure randomly generated password
- The database is accessible through a defined endpoint

To use this configuration, you would need to:
1. Have AWS credentials configured
2. Have the AWS provider and random provider installed
3. Run `terraform init` to initialize the providers
4. Run `terraform plan` to see the execution plan
5. Run `terraform apply` to create the resources

When you want to delete the database, running `terraform destroy` will automatically create a final snapshot before deletion.