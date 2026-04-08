# main.tf

# Run first:
# gcloud services enable cloudresourcemanager.googleapis.com
# gcloud services enable serviceusage.googleapis.com

resource "google_project_service" "apis" {
  for_each = toset([
    "storage.googleapis.com",
    "cloudkms.googleapis.com",
    "privateca.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com",
    "run.googleapis.com",
    "eventarc.googleapis.com"
  ])

  project = var.project_id
  service = each.key
  
  # Set this to false for all services managed by Terraform.
  # It ensures that if you destroy the infrastructure, the APIs are disabled,
  # preventing billing for unused services.
  disable_on_destroy = false
}

resource "random_id" "suffix" {
  byte_length = 4
}


# Data source to get details about the current project, including its number.
data "google_project" "project" {}