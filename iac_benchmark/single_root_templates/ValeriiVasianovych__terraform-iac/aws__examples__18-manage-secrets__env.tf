# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/env_keys/env/terraform.tfstate"
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

variable "db_username" {
    type = string
    description = "The username for the database using ENV variable."
}

variable "db_password" {
    type = string
    description = "The password for the database using ENV variable."
}

# ── outputs.tf ────────────────────────────────────
output "region" {
  value = data.aws_region.current.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "db_username" {
  value = var.db_username
  sensitive = false
}

output "db_password" {
  value     = var.db_password
  sensitive = false
}


# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


# ── db.tf ────────────────────────────────────
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

  username             = var.db_username
  password             = var.db_password
}

# export TF_VAR_db_username="admin"    
# export TF_VAR_db_password="adminpassword"