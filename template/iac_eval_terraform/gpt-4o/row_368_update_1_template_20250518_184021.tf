provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_database" "mysql_db" {
  name                = "my-mysql-database"
  availability_zone   = "us-east-1a"
  blueprint_id        = "mysql_5_7"
  bundle_id           = "medium_1_0"
  master_database_name = "mydatabase"
  master_username     = "admin"
  master_user_password = "YourSecurePassword123!"

  backup_retention_enabled = true
  preferred_backup_window  = "16:00-16:30"
  preferred_maintenance_window = "tue:17:00-tue:17:30"
}