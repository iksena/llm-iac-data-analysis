#Copyright 2022 Google

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}
// [START artifactregistry_create_docker_repo]
resource "google_artifact_registry_repository" "main" {
  location      = "us"
  repository_id = "main"
  format        = "DOCKER"
  project       = var.project_id
}
// [END artifactregistry_create_docker_repo]

module "network" {
  source     = "../modules/network"
  project_id = var.project_id
}
# [START gke_autopilot_private_regional_primary_cluster]
module "gke-db1-autopilot" {
  source                          = "../modules/beta-autopilot-private-cluster"
  project_id                      = var.project_id
  name                            = "cluster-db1"
  kubernetes_version              = "1.25" # Will be ignored if use "REGULAR" release_channel
  region                          = "us-central1"
  regional                        = true
  zones                           = ["us-central1-a", "us-central1-b", "us-central1-c"]
  network                         = module.network.network_name
  subnetwork                      = module.network.primary_subnet_name
  ip_range_pods                   = "ip-range-pods-db1"
  ip_range_services               = "ip-range-svc-db1"
  horizontal_pod_autoscaling      = true
  release_channel                 = "RAPID" # Default version is 1.22 in REGULAR. GMP on Autopilot requires V1.25 via var.kubernetes_version
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = false
  enable_private_nodes            = true
  master_ipv4_cidr_block          = "172.16.0.0/28"
  create_service_account          = false
}
# [END gke_autopilot_private_regional_primary_cluster]
# [START gke_autopilot_private_regional_backup_cluster]
module "gke-db2-autopilot" {
  source                          = "../modules/beta-autopilot-private-cluster"
  project_id                      = var.project_id
  name                            = "cluster-db2"
  kubernetes_version              = "1.25" # Will be ignored if use "REGULAR" release_channel
  region                          = "us-west1"
  regional                        = true
  zones                           = ["us-west1-a", "us-west1-b", "us-west1-c"]
  network                         = module.network.network_name
  subnetwork                      = module.network.secondary_subnet_name
  ip_range_pods                   = "ip-range-pods-db2"
  ip_range_services               = "ip-range-svc-db2"
  horizontal_pod_autoscaling      = true
  release_channel                 = "RAPID" # Default version is 1.22 in REGULAR. GMP on Autopilot requires V1.25 via var.kubernetes_version
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = false
  enable_private_nodes            = true
  master_ipv4_cidr_block          = "172.16.0.16/28"
  create_service_account          = false
}
# [END gke_autopilot_private_regional_backup_cluster]
