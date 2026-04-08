# GCS Bucket
resource "google_storage_bucket" "bucket" {
  name          = local.bucket.name
  location      = local.bucket.region
  project       = local.gcp_project_id
  uniform_bucket_level_access = true
  depends_on = [ google_project_service.apis ]
}

# Grant Cloud Logging service account access so logging sinks can write to the bucket.
# This is the Google-managed logging service account used by Logging sinks.
resource "google_storage_bucket_iam_member" "logging_sa" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:service-538882805832@gcp-sa-logging.iam.gserviceaccount.com"

  # Ensure APIs/bucket exist before binding
  depends_on = [ google_storage_bucket.bucket ]
}
