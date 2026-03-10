# ── main.tf ────────────────────────────────────
provider "google" {
  project = "terraform-gcp-module-test"
  region  = "us-central1"
  project = "terraform-gcp-module-test"
}

resource "google_compute_network" "demo_network" {
  name                    = "${var.gn_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "demo_subnetwork" {
  network       = "${google_compute_network.demo_network.name}"
  name          = "${var.sn_name}"
  region        = "${var.sn_region}"
  ip_cidr_range = "${var.sn_cidr_range}"
}


# ── outputs.tf ────────────────────────────────────
output "compute_network_consumable" {
  value       = "${google_compute_network.demo_network.name}"
  description = "The Network Name"
}

output "subnetwork_consumable_name" {
  value       = "${google_compute_subnetwork.demo_subnetwork.name}"
  description = "The Subnet Name"
}

output "subnetwork_consumable_ip_cidr_range" {
  value       = "${google_compute_subnetwork.demo_subnetwork.ip_cidr_range}"
  description = "The default Cidr Range"
}


# ── _interface.tf ────────────────────────────────────
variable "gn_name" {
  default     = ""
  description = "The default name for the Compute Network"
}

variable "sn_name" {
  default     = ""
  description = "The default name for the subnet"
}

variable "sn_region" {
  default     = ""
  description = "The default region for the subnet"
}

variable "sn_cidr_range" {
  default     = ""
  description = "The default Subnet Cidr Range"
}
