locals {
  gcp_project_id               = "cloud-ai-police"
  gcp_region                   = "us-central1"
  
  service_account_display_name = "cloud-ai-police-sa"

  apis_to_enable = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "aiplatform.googleapis.com",
    "container.googleapis.com",
    "run.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]

  bucket = {
    name   = "cloud-ai-police-bucket-0"
    region = local.gcp_region
  }

  gar = {
    repository_id = "cloud-ai-police-gar"
    location      = local.gcp_region
    description   = "Docker repository for cloud-ai-police"
    format        = "DOCKER"
  }

  iam_roles = [
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountUser",
    "roles/run.admin",
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.admin",
    "roles/storage.admin",
    "roles/storage.objectAdmin",
    "roles/storage.objectViewer",
    "roles/storage.objectCreator",
    "roles/aiplatform.admin",
    "roles/container.admin",
    "roles/logging.admin",
    "roles/monitoring.admin"
  ]

  gke = {
    name               = "cloud-ai-police-gke"
    location           = "us-central1-a" # To avoid zonal SSD limitation issues
    initial_node_count = 1
    node_machine_type  = "e2-medium"
    node_pool_name     = "default-pool"
    min_node_count     = 1
    max_node_count     = 1
    disk_size_gb       = 30
    disk_type          = "pd-standard"
  }

  log_sink = {
    name        = "cloud-ai-police-log-gcs-sink"
    destination = "storage.googleapis.com/${local.bucket.name}"
    filter      = "resource.labels.namespace_name=\"default\" AND severity>=WARNING"
  }
}
