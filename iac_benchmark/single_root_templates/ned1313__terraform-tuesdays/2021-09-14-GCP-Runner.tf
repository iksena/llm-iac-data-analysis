# ── main.tf ────────────────────────────────────
# Create a project to host the runner MIG
module "project" {
  source          = "./project_creation"
  billing_account = var.billing_account
  org_id          = var.org_id
  region          = var.region
  prefix          = var.prefix
}

# Create a service account for the MIG
resource "google_service_account" "service_account" {
  account_id   = local.gcp_service_account_name
  display_name = local.gcp_service_account_name
  project      = module.project.project_id
}

# Apply proper permissions for service account as a runner
resource "google_organization_iam_member" "organization" {
  for_each = toset([
    "roles/viewer",
    "roles/resourcemanager.projectCreator",
  "roles/billing.user"])
  org_id  = var.org_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Create the MIG
module "github-actions-runners_gh-runner-mig-vm" {
  source          = "./runner_creation"
  create_network  = true
  project_id      = module.project.project_id
  region          = var.region
  zone            = var.zone
  org_name        = var.gh_org_name
  org_url         = var.gh_org_url
  gh_token        = var.gh_token
  service_account = google_service_account.service_account.email
}

# Create the storage account
resource "google_storage_bucket" "tf_state" {
  name          = "${module.project.project_id}-terraform-state"
  location      = var.gcp_bucket_location
  force_destroy = true
  project       = module.project.project_id

  uniform_bucket_level_access = true
}

# Allow the service account access to the bucket for state management
resource "google_storage_bucket_iam_binding" "gh_runner_allow" {
  bucket = google_storage_bucket.tf_state.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
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

variable "zone" {
  type        = string
  description = "Default zone to use for MIG runner deployment"
  default     = "us-central1-a"
}

variable "gcp_bucket_location" {
  type        = string
  description = "Location of Google Cloud bucket"
  default     = "US"
}

variable "gh_org_name" {
  type        = string
  description = "Name of the GitHub organization to request a runner token from"
}

variable "gh_org_url" {
  type        = string
  description = "URL for the GitHub organization to register a runner with."
}

variable "gh_token" {
  type        = string
  description = "GitHub token with permissions to request a runner token."
}

variable "prefix" {
  type        = string
  description = "Prefix for naming the project and other resources"
  default     = "taco"
}

locals {
  gcp_service_account_name = "${var.prefix}-gh-runner-account"
}

# ── output.tf ────────────────────────────────────
output "bucket_name" {
  value = google_storage_bucket.tf_state.name
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.0"
    }
  }

  # Maybe add to Terraform Cloud later?
}