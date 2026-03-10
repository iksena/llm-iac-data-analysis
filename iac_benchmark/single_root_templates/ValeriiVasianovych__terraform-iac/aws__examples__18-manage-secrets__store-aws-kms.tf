# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/env_keys/kms/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16"
    }
  }
}
provider "aws" {
  region = var.region
}

# ── variables.tf ────────────────────────────────────
variable "region" {
    description = "The AWS region to launch the resources."
    type        = string
    default     = "us-east-1"
}

# ── outputs.tf ────────────────────────────────────
output "region" {
  value = data.aws_region.current.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "db_creds_username" {
  value = local.db_creds.username
  sensitive = true
}

output "db_creds_password" {
  value = local.db_creds.password
  sensitive = true
}

# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_kms_secrets" "creds" {
  secret {
    name = "db"
    payload = file("${path.module}/db_creds.yaml.encrypted")
  }
}

# ── db.tf ────────────────────────────────────
locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

resource "aws_db_instance" "mysql" {
  identifier           = "mysql-db"         # It is the name of the database instance.
  publicly_accessible  = true               # It means that the database is accessible from the internet.
  allocated_storage    = 5                  # It is the size of the storage in GB.
  storage_type         = "gp2"              # It is the type of storage.
  engine               = "mysql"            # It is the engine of the database.
  engine_version       = "5.7"              # It is the version of MySQL.
  instance_class       = "db.t3.micro"      # It is the smallest instance class.
  parameter_group_name = "default.mysql5.7" # It is the default parameter group for MySQL 5.7.
  skip_final_snapshot  = true               # It means that when the instance is deleted, it will not take the final snapshot.
  apply_immediately    = true               # It means that the changes (for example, changing the engine version) will be applied immediately.

  username             = local.db_creds.username
  password             = local.db_creds.password
}
