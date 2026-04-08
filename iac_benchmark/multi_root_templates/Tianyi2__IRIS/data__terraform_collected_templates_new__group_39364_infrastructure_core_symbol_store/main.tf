resource "google_storage_bucket" "store" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true

  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  uniform_bucket_level_access = true
}

