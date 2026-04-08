resource "google_storage_bucket" "bucket" {
  name          = var.name
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy
  
  uniform_bucket_level_access = var.uniform_bucket_level_access

  versioning {
    enabled = var.versioning
  }
}

# Grant access to the bucket to the principals
resource "google_storage_bucket_iam_member" "bucket-principals" {
  for_each = toset(var.principals)
  bucket   = google_storage_bucket.bucket.name
  role     = "roles/storage.objectUser"
  member   = each.value
}
