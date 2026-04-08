locals {
    zip2_filename = "${path.module}/cloud_function_source_2.zip"
}

# Create a zip archive with the cloud function's source code
data "archive_file" "cloud_function_source_2_zip" {
  type        = "zip"
  source_dir  = var.source_2_path
  excludes    = [".git"]
  output_path = local.zip2_filename
}

# Upload the cloud function's source code to the storage bucket
resource "google_storage_bucket_object" "cloud_function_bucket_object_2" {
  name   = format("cloud_function_source_2.%s.zip", data.archive_file.cloud_function_source_2_zip.output_md5)
  bucket = google_storage_bucket.cloud_function_source_bucket.name
  source = local.zip2_filename
}

# Deploy the cloud function
resource "google_cloudfunctions_function" "function_2" {
  depends_on = [google_storage_bucket_iam_member.function_symbol_store_access]

  name                  = "AdminAPI"
  description           = "Legacy Admin API => Backend API redirect"
  runtime               = "go119"
  region                = var.function_region
  service_account_email = google_service_account.function_service_account.email

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.cloud_function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_bucket_object_2.name
  trigger_http          = true
  entry_point           = "RedirectAPI"
  environment_variables = {
    TARGET_URI = google_cloudfunctions_function.function.https_trigger_url
  }
}

# Create an IAM entry for invoking the function
# This IAM entry allows anyone to invoke the function via HTTP, without being authenticated
resource "google_cloudfunctions_function_iam_member" "allow_unauthenticated_invocation_2" {
  project        = google_cloudfunctions_function.function_2.project
  region         = google_cloudfunctions_function.function_2.region
  cloud_function = google_cloudfunctions_function.function_2.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

# Deploy the cloud function
resource "google_cloudfunctions_function" "function_3" {
  depends_on = [google_storage_bucket_iam_member.function_symbol_store_access]

  name                  = "DownloadAPI"
  description           = "Legacy Download API => Backend API redirect"
  runtime               = "go119"
  region                = var.function_region
  service_account_email = google_service_account.function_service_account.email

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.cloud_function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_bucket_object_2.name
  trigger_http          = true
  entry_point           = "RedirectAPI"
  environment_variables = {
    TARGET_URI = "${google_cloudfunctions_function.function.https_trigger_url}/httpSymbolStore"
  }
}

# Create an IAM entry for invoking the function
# This IAM entry allows anyone to invoke the function via HTTP, without being authenticated
resource "google_cloudfunctions_function_iam_member" "allow_unauthenticated_invocation_3" {
  project        = google_cloudfunctions_function.function_3.project
  region         = google_cloudfunctions_function.function_3.region
  cloud_function = google_cloudfunctions_function.function_3.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
