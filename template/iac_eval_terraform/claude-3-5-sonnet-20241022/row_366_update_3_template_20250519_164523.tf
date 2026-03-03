terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_database" "mysql_db" {
  relational_database_name = "my-mysql-db"
  availability_zone       = "us-east-1a"
  master_database_name    = "maindb"
  master_username        = "dbadmin"
  master_password        = "Password123!"
  blueprint_id           = "mysql_8_0"
  bundle_id             = "micro_2_0"
  skip_final_snapshot   = true
}

output "database_endpoint" {
  value = aws_lightsail_database.mysql_db.master_endpoint_address
}