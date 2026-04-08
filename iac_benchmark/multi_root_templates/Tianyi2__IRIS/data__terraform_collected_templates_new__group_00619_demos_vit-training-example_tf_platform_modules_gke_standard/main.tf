# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}


# GKE cluster
resource "google_container_cluster" "ml_cluster" {
  name     = var.cluster_name
  location = var.zone
  min_master_version = 1.27
  count    = 1
  remove_default_node_pool = true
  initial_node_count = 1

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    gcs_fuse_csi_driver_config {
        enabled = true
    }
    gcp_filestore_csi_driver_config {
        enabled = true
    }
  }
  deletion_protection = false
}

resource "google_container_node_pool" "gpu_pool" {
  name       = "gpu-pool"
  location   = var.zone
  cluster    = google_container_cluster.ml_cluster[0].name
  node_count = var.num_gpu_nodes

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    image_type   = "cos_containerd"
    machine_type = "g2-standard-16"
    tags         = ["gke-node", "${var.project_id}-gke"]

    disk_size_gb = "100"
    disk_type    = "pd-ssd"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    guest_accelerator {
      type  = "nvidia-l4"
      count = 1
    }
  }
}
