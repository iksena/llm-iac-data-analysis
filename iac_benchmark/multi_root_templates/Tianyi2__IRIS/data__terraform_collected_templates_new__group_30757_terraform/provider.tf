provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "dns_api" {
  service = "dns.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}