output "cloud_run_service_url" {
  description = "URL of the deployed n8n Cloud Run service."
  value       = google_cloud_run_v2_service.n8n.uri
} 
