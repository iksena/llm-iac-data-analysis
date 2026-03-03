The Terraform program will provision an AWS Lightsail PostgreSQL database instance. It will be configured to take a final snapshot when the database is deleted. The configuration will include the necessary IAM roles and policies to manage the database instance. The AWS provider will be configured to use a specific region, and all necessary parameters for the database instance will be defined, including the database name, username, and password. Default values will be provided for any variables used in the configuration.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lightsail_role" {
  name = "lightsailDatabaseRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lightsail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lightsail_policy" {
  name   = "lightsailDatabasePolicy"
  role   = aws_iam_role.lightsail_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lightsail:CreateRelationalDatabase",
          "lightsail:DeleteRelationalDatabase",
          "lightsail:GetRelationalDatabase",
          "lightsail:CreateRelationalDatabaseSnapshot",
          "lightsail:DeleteRelationalDatabaseSnapshot"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lightsail_database" "postgres_db" {
  name                = "my-postgres-db"
  availability_zone   = "us-east-1a"
  blueprint_id        = "postgresql_12_4"
  bundle_id           = "medium_1_0"
  master_database_name = "mydatabase"
  master_username     = "admin"
  master_password     = "SuperSecretPassword123!"

  final_snapshot_name = "final-snapshot"

  lifecycle {
    prevent_destroy = false
  }
}
```
</iac_template>