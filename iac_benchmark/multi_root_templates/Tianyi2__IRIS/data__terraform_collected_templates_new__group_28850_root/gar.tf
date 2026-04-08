# Google Artifact Registry Repository
resource "google_artifact_registry_repository" "repository" {
  project       = local.gcp_project_id
  location      = local.gar.location
  repository_id = local.gar.repository_id
  description   = local.gar.description
  format        = local.gar.format
  depends_on = [ google_project_service.apis ]
}
