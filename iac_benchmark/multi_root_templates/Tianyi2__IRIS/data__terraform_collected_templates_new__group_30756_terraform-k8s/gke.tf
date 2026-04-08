# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network configuration
  network    = "default"
  subnetwork = "default"

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Release channel for automatic updates
  release_channel {
    channel = "REGULAR"
  }

  # Maintenance window
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  # Enable basic features
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  # IP allocation policy for VPC-native cluster
  ip_allocation_policy {}

  depends_on = [
    google_project_service.container,
    google_project_service.compute
  ]
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.gke_cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_node_count

  # Autoscaling configuration
  autoscaling {
    min_node_count = var.gke_min_nodes
    max_node_count = var.gke_max_nodes
  }

  # Node configuration
  node_config {
    preemptible  = false
    machine_type = var.gke_machine_type
    disk_size_gb = var.gke_disk_size_gb
    disk_type    = "pd-standard"

    # Google recommends custom service accounts with minimal permissions
    service_account = google_service_account.gke_node.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Workload Identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Labels
    labels = {
      environment = var.environment
      project     = var.project_name
    }

    # Tags for firewall rules
    tags = ["gke-node", "${var.environment}-${var.project_name}"]

    # Metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  # Node management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

# Service Account for GKE nodes
resource "google_service_account" "gke_node" {
  account_id   = "${var.environment}-${var.project_name}-gke-sa"
  display_name = "GKE Node Service Account for ${var.environment}"
}

# IAM bindings for GKE service account
resource "google_project_iam_member" "gke_node_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_node.email}"
}

resource "google_project_iam_member" "gke_node_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_node.email}"
}

resource "google_project_iam_member" "gke_node_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_node.email}"
}
