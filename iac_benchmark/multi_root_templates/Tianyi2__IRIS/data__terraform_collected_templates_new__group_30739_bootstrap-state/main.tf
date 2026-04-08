terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

# 1. Create the GCS bucket for the main project's remote state
resource "google_storage_bucket" "tfstate" {
  name          = "${var.project_id}-tfstate"
  location      = var.location
  project       = var.project_id
  #force_destroy = false # Protect this bucket!
  force_destroy = true
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle {
  # prevent_destroy = true
  prevent_destroy = false
  }
}

# 2. Create the Secret in Secret Manager
resource "google_secret_manager_secret" "tfstate_bucket_name_secret" {
  project   = var.project_id
  secret_id = "tfstate-bucket-name"

  replication {
    auto {}
  }

  # Ensure the bucket is created before the secret that refers to it
  depends_on = [google_storage_bucket.tfstate]
}

# 3. Store the bucket name as a version in the secret
resource "google_secret_manager_secret_version" "tfstate_bucket_name_version" {
  secret      = google_secret_manager_secret.tfstate_bucket_name_secret.id
  secret_data = google_storage_bucket.tfstate.name
}

resource "google_project_service" "apis" {
  for_each = toset([
        "storage.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "secretmanager.googleapis.com"
  ])
  project = var.project_id
  service = each.key
}
