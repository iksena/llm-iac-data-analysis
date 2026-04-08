output "tfstate_bucket_name" {
  description = "Name of the GCS bucket created for Terraform state."
  value       = google_storage_bucket.tfstate.name
}

output "secret_id" {
  description = "ID of the Secret Manager secret holding the bucket name."
  value       = google_secret_manager_secret.tfstate_bucket_name_secret.secret_id
}
