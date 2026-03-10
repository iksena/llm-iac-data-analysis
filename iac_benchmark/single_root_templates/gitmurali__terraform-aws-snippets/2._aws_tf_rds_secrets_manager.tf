# ── main.tf ────────────────────────────────────
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  }
  backend "s3" {
    bucket = "my-rds-secrets-bucket"
    key    = "rds_tf_state/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

# ── variables.tf ────────────────────────────────────
variable "allocated_storage" {
  description = "The amount of storage to allocate"
  type        = number
  default     = 20
  sensitive   = true
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "mariadb"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "10.4.25"
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t4g.small"
}

variable "default_tag" {
  type        = string
  description = "A default tag to add to everything"
  default     = "terraform_aws_rds_secrets_manager"
}

# ── kms_key.tf ────────────────────────────────────
# KMS key used by Secrets Manager for RDS
resource "aws_kms_key" "default" {
  description             = "KMS key for RDS"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Name = var.default_tag
  }
}

# ── rds.tf ────────────────────────────────────
data "aws_secretsmanager_secret" "example" {
  name = "rds_admin6"
  depends_on = [
    aws_secretsmanager_secret.example
  ]
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.example.id
}

resource "aws_db_instance" "default" {
  identifier              = "my-database"
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = "Admin"
  password                = data.aws_secretsmanager_secret_version.secret.secret_string
  parameter_group_name    = "default.mariadb10.4"
  skip_final_snapshot     = true
  publicly_accessible     = true
  multi_az                = false
  storage_encrypted       = true
  backup_retention_period = 7

  tags = {
    Name = var.default_tag
  }
}

# ── secrets_manager.tf ────────────────────────────────────
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "example" {
  kms_key_id              = aws_kms_key.default.key_id
  name                    = "rds_admin6"
  description             = "RDS Admin password"
  recovery_window_in_days = 14

  tags = {
    Name = var.default_tag
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = random_password.password.result
}