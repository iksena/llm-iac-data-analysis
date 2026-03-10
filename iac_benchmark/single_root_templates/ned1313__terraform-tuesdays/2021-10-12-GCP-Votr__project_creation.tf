# ── main.tf ────────────────────────────────────
# Create a Google project for Compute Engine
resource "google_project" "project" {
  name            = var.prefix
  project_id      = var.prefix
  billing_account = var.billing_account
  org_id          = var.org_id
}

# Enable the necessary services on the project for deployments
resource "google_project_service" "service" {
  for_each = toset(var.services)

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

# ── variables.tf ────────────────────────────────────

variable "billing_account" {
  type        = string
  description = "Billing account to associate with the project being created."
}

variable "org_id" {
  type        = string
  description = "Organization ID to associate with the project being created"
}
variable "region" {
  type        = string
  description = "Default region to use for the project"
  default     = "us-central1"
}

variable "prefix" {
  type        = string
  description = "Prefix for naming the project and other resources"
}

variable "services" {
  type = list(string)
  description = "List of services to enable for project"
  default = [
    "compute.googleapis.com",
    "appengine.googleapis.com",
    "appengineflex.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

# ── output.tf ────────────────────────────────────
# Provide the project information for another user
output "project_id" {
  value = google_project.project.project_id
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.0"
    }
  }
}


provider "google" {
  region = var.region
}