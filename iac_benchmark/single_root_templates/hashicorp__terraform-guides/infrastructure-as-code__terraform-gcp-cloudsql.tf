# ── main.tf ────────────────────────────────────
provider "google" {
  credentials = "${var.gcp_credentials}"
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}

# Random identifier for Database name
resource "random_pet" "database_name" {
  prefix = "${var.database_name_prefix}"
  separator = "-"
}

resource "google_sql_database_instance" "cloudsql-postgres-master" {
  name = "${random_pet.database_name.id}"
  database_version = "${var.database_version}"
  region = "${var.region}"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
            ipv4_enabled = true
            require_ssl = false
            authorized_networks = {
                name = "terraform-server-IP-allowed-list"
                value = "${var.authorized_network}"
            }
        }
  }
}

resource "google_sql_user" "users" {
  name     = "${var.gcp_sql_root_user_name}"
  instance = "${google_sql_database_instance.cloudsql-postgres-master.name}"
  password = "${var.gcp_sql_root_user_pw}"
}


# ── variables.tf ────────────────────────────────────
variable "gcp_credentials" {
  description = "GCP credentials needed by Google Terraform provider"
}

variable "gcp_project" {
  description = "GCP project name needed by Google Terraform provider"
}

variable "region" {
  default = "us-central1"
}

variable "gcp_sql_root_user_name" {
  default = "root"
}

variable "gcp_sql_root_user_pw" {}

variable "authorized_network" {}

variable "database_name_prefix" {
  default = "cloudsql-master"
}

variable "database_version" {
  default = "POSTGRES_9_6"
}



# ── outputs.tf ────────────────────────────────────
output "connection_name" {
  value = "${google_sql_database_instance.cloudsql-postgres-master.connection_name}"
}

output "ip" {
  value = "${google_sql_database_instance.cloudsql-postgres-master.ip_address.0.ip_address}"
}

