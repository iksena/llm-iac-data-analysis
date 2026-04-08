# Artifact Registry Repository for Docker images
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.artifact_registry_location
  repository_id = var.artifact_registry_repository
  description   = "Docker repository for ${var.environment} environment"
  format        = "DOCKER"

  labels = {
    environment = var.environment
    project     = var.project_name
  }

  depends_on = [google_project_service.artifact_registry]
}

# IAM binding to allow GKE to pull images
resource "google_artifact_registry_repository_iam_member" "gke_reader" {
  project    = var.project_id
  location   = google_artifact_registry_repository.docker_repo.location
  repository = google_artifact_registry_repository.docker_repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.gke_node.email}"
}
