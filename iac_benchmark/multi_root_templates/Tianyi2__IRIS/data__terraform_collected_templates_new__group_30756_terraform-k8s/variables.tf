variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for zonal resources"
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Environment name (testing)"
  type        = string
  default     = "testing"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "coinbreakr"
}

variable "gke_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "gke_node_count" {
  description = "Initial number of nodes in the GKE cluster"
  type        = number
  default     = 1
}

variable "gke_min_nodes" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "gke_max_nodes" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 5
}

variable "gke_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "gke_disk_size_gb" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 50
}

variable "artifact_registry_location" {
  description = "Location for Artifact Registry"
  type        = string
  default     = "us-central1"
}

variable "artifact_registry_repository" {
  description = "Name of the Artifact Registry repository"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 3000
}

variable "k8s_namespace" {
  description = "Kubernetes namespace for application"
  type        = string
  default     = "default"
}
