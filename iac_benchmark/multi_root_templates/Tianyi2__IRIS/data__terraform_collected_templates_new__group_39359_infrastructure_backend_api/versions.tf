terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.0"
    }

    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "~> 1.17.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "google" {
  project = var.project_id
}

provider "postgresql" {
  scheme          = "gcppostgres"
  host            = "${var.project_id}/${var.database_region}/${var.database_instance_name}"
  port            = 5432
  username        = var.admin_user_name
  password        = var.admin_user_password
  superuser       = false
}
