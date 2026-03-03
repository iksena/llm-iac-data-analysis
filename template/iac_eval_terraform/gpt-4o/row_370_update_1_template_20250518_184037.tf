provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_database" "postgres_db" {
  name                = "my-postgres-db"
  availability_zone   = "us-east-1a"
  blueprint_id        = "postgresql_13_3"
  bundle_id           = "medium_1_0"
  master_database_name = "mydatabase"
  master_username     = "admin"
  master_user_password = "SuperSecretPassword123!"

  apply_immediately = true

  tags = {
    Environment = "Production"
    Name        = "PostgresDB"
  }
}

output "database_endpoint" {
  value = aws_lightsail_database.postgres_db.endpoint
}

output "database_port" {
  value = aws_lightsail_database.postgres_db.port
}