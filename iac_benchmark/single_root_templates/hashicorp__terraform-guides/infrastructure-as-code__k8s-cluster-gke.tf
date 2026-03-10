# ── main.tf ────────────────────────────────────
terraform {
  required_version = ">= 0.11.11"
}

provider "vault" {
  address = "${var.vault_addr}"
}

data "vault_generic_secret" "gcp_credentials" {
  path = "secret/${var.vault_user}/gcp/credentials"
}

provider "google" {
  credentials = "${data.vault_generic_secret.gcp_credentials.data[var.gcp_project]}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

resource "google_container_cluster" "k8sexample" {
  name               = "${var.vault_user}-k8s-cluster"
  description        = "example k8s cluster"
  zone               = "${var.gcp_zone}"
  initial_node_count = "${var.initial_node_count}"
  enable_kubernetes_alpha = "true"
  enable_legacy_abac = "true"

  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  node_config {
    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}


# ── variables.tf ────────────────────────────────────
variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default = "us-east1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-b (which must be in gcp_region)"
  default = "us-east1-b"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "initial_node_count" {
  description = "Number of worker VMs to initially create"
  default = 1
}

variable "master_username" {
  description = "Username for accessing the Kubernetes master endpoint"
  default = "k8smaster"
}

variable "master_password" {
  description = "Password for accessing the Kubernetes master endpoint"
  default = "k8smasterk8smaster"
}

variable "node_machine_type" {
  description = "GCE machine type"
  default = "n1-standard-1"
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  default = "20"
}

variable "environment" {
  description = "value passed to Environment tag and used in name of Vault auth backend later"
  default = "gke-dev"
}

variable "vault_user" {
  description = "Vault userid: determines location of secrets and affects path of k8s auth backend"
}

variable "vault_addr" {
  description = "Address of Vault server including port"
}


# ── outputs.tf ────────────────────────────────────
output "k8s_endpoint" {
  value = "${google_container_cluster.k8sexample.endpoint}"
}

output "k8s_master_version" {
  value = "${google_container_cluster.k8sexample.master_version}"
}

output "k8s_instance_group_urls" {
  value = "${google_container_cluster.k8sexample.instance_group_urls.0}"
}

output "k8s_master_auth_client_certificate" {
  value = "${google_container_cluster.k8sexample.master_auth.0.client_certificate}"
}

output "k8s_master_auth_client_key" {
  value = "${google_container_cluster.k8sexample.master_auth.0.client_key}"
}

output "k8s_master_auth_cluster_ca_certificate" {
  value = "${google_container_cluster.k8sexample.master_auth.0.cluster_ca_certificate}"
}

output "environment" {
  value = "${var.environment}"
}

output "vault_user" {
  value = "${var.vault_user}"
}

output "vault_addr" {
  value = "${var.vault_addr}"
}
