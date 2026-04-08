# secret_manager.tf

### Provision Secrets ###

# Author name
resource "google_secret_manager_secret" "author_name_secret" {
  project   = var.project_id
  secret_id = "c2pa-author-name"

  replication {
    auto {}
  }
  depends_on = [
    google_project_service.apis["secretmanager.googleapis.com"]
  ]

}

# Author Org
resource "google_secret_manager_secret" "author_org_secret" {
  project   = var.project_id
  secret_id = "c2pa-author-org"

  replication {
    auto {}
  }

    depends_on = [
    google_project_service.apis["secretmanager.googleapis.com"]
  ]
}


# Claim Generator
resource "google_secret_manager_secret" "claim_generator_secret" {
  project   = var.project_id
  secret_id = "c2pa-claim-generator"

  replication {
    auto {}
  }

    depends_on = [
    google_project_service.apis["secretmanager.googleapis.com"]
  ]
}

### Set Secret Values ###

# Author Name
resource "google_secret_manager_secret_version" "author_name_version" {
  secret      = google_secret_manager_secret.author_name_secret.id
  secret_data = var.c2pa_author_name
}

# Author Org
resource "google_secret_manager_secret_version" "author_org_version" {
  secret      = google_secret_manager_secret.author_org_secret.id
  secret_data = var.c2pa_author_org
}

resource "google_secret_manager_secret_version" "claim_generator_version" {
  secret      = google_secret_manager_secret.claim_generator_secret.id
  secret_data = var.c2pa_claim_generator
}
