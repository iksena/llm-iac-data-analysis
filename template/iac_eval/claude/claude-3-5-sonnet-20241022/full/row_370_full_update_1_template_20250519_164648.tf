I'll help you create a Terraform configuration for an AWS Lightsail PostgreSQL database instance with immediate changes enabled. This configuration will:

1. Set up an AWS Lightsail PostgreSQL database instance
2. Configure the database to apply changes immediately
3. Set up necessary parameters like database name, master username, and password
4. Enable backup retention
5. Specify the database version and instance size

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
  master_database_name   = "main_database"
  master_username       = "dbadmin"
  master_password      = random_password.master_password.result
  blueprint_id         = "postgres_12"
  bundle_id           = "micro_2_0"
  
  # Enable immediate application of changes
  apply_immediately   = true
  
  # Configure backup retention
  backup_retention_enabled = true
  
  # Configure backup window
  preferred_backup_window = "03:00-04:00"
  
  # Configure maintenance window
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  # Public accessibility
  public_accessible = false

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Output the database endpoint
output "database_endpoint" {
  value = aws_lightsail_database.postgres_db.master_endpoint_address
}

# Output the database username
output "database_username" {
  value = aws_lightsail_database.postgres_db.master_username
}

# Output the database password
output "database_password" {
  value     = random_password.master_password.result
  sensitive = true
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Creates a random password generator for the database master password
3. Creates a Lightsail PostgreSQL database with the following specifications:
   - PostgreSQL 12
   - Micro 2.0 bundle (suitable for development/small production workloads)
   - Automatic backups enabled with a 1-hour backup window
   - Maintenance window set to Sunday 5-6 AM
   - Immediate application of changes enabled via `apply_immediately = true`
   - Private access only (not publicly accessible)
4. Outputs important information like database endpoint, username, and password

The configuration uses the micro_2_0 bundle, which is cost-effective while still providing good performance for small to medium workloads. The database is set up with private access by default for security purposes.

To use this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

The database will be created with immediate changes enabled, meaning any modifications to the database configuration will be applied right away instead of waiting for the maintenance window.