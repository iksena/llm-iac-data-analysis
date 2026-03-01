To address the business need, we will create an AWS Lightsail PostgreSQL database instance using Terraform. The configuration will ensure that changes to the database are applied immediately, bypassing the default maintenance window. We will define the necessary AWS provider configuration, create a Lightsail database instance, and set the parameter to apply changes immediately. Additionally, we will include IAM roles and policies if needed for managing the database.

<iac_template>

```hcl
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
```

</iac_template>

This Terraform configuration will create a PostgreSQL database in AWS Lightsail with the specified parameters. The `apply_immediately` attribute is set to `true` to ensure that any changes are applied immediately rather than waiting for a maintenance window. The configuration also outputs the database endpoint and port for easy access.