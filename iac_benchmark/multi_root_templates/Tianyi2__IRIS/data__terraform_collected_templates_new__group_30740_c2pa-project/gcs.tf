# gcs.tf

resource "google_storage_bucket" "uploads" {
  for_each = toset(var.regions)
  name          = "c2pa-uploads-${each.value}-${random_id.suffix.hex}"
  location      = each.key
  force_destroy = true
  project       = var.project_id
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "signed" {
  name          = "c2pa-signed-${random_id.suffix.hex}"
  location      = var.location
  force_destroy = true
  project       = var.project_id
  uniform_bucket_level_access = true
}
