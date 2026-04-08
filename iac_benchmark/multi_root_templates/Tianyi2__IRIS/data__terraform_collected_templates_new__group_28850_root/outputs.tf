output "service_account_email" {
  description = "The email of the created service account."
  value       = google_service_account.service_account.email
}

output "bucket_name" {
  description = "The name of the GCS bucket."
  value       = google_storage_bucket.bucket.name
}

output "gar_repository_name" {
  description = "The name of the GAR repository."
  value       = google_artifact_registry_repository.repository.name
}
