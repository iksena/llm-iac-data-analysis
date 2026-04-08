#Copyright 2022 Google LLC

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
# [START artifactregistry_docker_repo]
resource "google_artifact_registry_repository" "main" {
  location      = "us"
  repository_id = "main"
  format        = "DOCKER"
  project       = var.project_id
}
resource "google_artifact_registry_repository_iam_binding" "binding" {
  provider   = google-beta
  project    = google_artifact_registry_repository.main.project
  location   = google_artifact_registry_repository.main.location
  repository = google_artifact_registry_repository.main.name
  role       = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:${module.kafka_us_central1.service_account}",
  ]
}

# [END artifactregistry_docker_repo]

module "network" {
  source     = "../modules/network"
  project_id = var.project_id
}
# [START gke_standard_private_regional_primary_cluster]
module "kafka_us_central1" {
  source                   = "../modules/beta-private-cluster"
  project_id               = var.project_id
  name                     = "gke-kafka-us-central1"
  regional                 = true
  region                   = "us-central1"
  network                  = module.network.network_name
  subnetwork               = module.network.primary_subnet_name
  ip_range_pods            = "ip-range-pods-us-central1"
  ip_range_services        = "ip-range-svc-us-central1"
  create_service_account   = true
  enable_private_endpoint  = false
  enable_private_nodes     = true
  master_ipv4_cidr_block   = "172.16.0.0/28"
  network_policy           = true
  logging_enabled_components = ["SYSTEM_COMPONENTS","WORKLOADS"]
  monitoring_enabled_components = ["SYSTEM_COMPONENTS"]
  enable_cost_allocation = true
  cluster_autoscaling = {
    "autoscaling_profile": "OPTIMIZE_UTILIZATION",
    "enabled" : true,
    "gpu_resources" : [],
    "min_cpu_cores" : 36,
    "min_memory_gb" : 144,
    "max_cpu_cores" : 70,
    "max_memory_gb" : 250,
  }
  monitoring_enable_managed_prometheus = true
  gke_backup_agent_config = true

  node_pools = [
    {
      name            = "pool-system"
      autoscaling     = true
      min_count       = 1
      max_count       = 2
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-4"
      node_locations  = "us-central1-a,us-central1-b,us-central1-c"
      auto_repair     = true
    },
    {
      name            = "pool-kafka"
      autoscaling     = false
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-8"
      node_locations  = "us-central1-a,us-central1-b,us-central1-c"
      auto_repair     = true
    },
    {
      name            = "pool-zookeeper"
      autoscaling     = false
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-8"
      node_locations  = "us-central1-a,us-central1-b,us-central1-c"
      auto_repair     = true
    },
  ]
  node_pools_labels = {
    all = {}
    pool-kafka = {
      "app.stateful/component" = "kafka-broker"
    }
    pool-zookeeper = {
      "app.stateful/component" = "zookeeper"
    }
  }
  node_pools_taints = {
    all = []
    pool-kafka = [
      {
        key    = "app.stateful/component"
        value  = "kafka-broker"
        effect = "NO_SCHEDULE"
      },
    ],
    pool-zookeeper = [
      {
        key    = "app.stateful/component"
        value  = "zookeeper"
        effect = "NO_SCHEDULE"
      },
    ],
  }
 gce_pd_csi_driver = true
}
  

# [END gke_standard_private_regional_primary_cluster]
# [START gke_standard_private_regional_backup_cluster]
module "gke-us-west1" {
  source                   = "../modules/beta-private-cluster"
  project_id               = var.project_id
  name                     = "gke-kafka-us-west1"
  regional                 = true
  region                   = "us-west1"
  network                  = module.network.network_name
  subnetwork               = module.network.secondary_subnet_name
  ip_range_pods            = "ip-range-pods-us-west1"
  ip_range_services        = "ip-range-svc-us-west1"
  create_service_account   = false
  service_account          = module.kafka_us_central1.service_account
  enable_private_endpoint  = false
  enable_private_nodes     = true
  master_ipv4_cidr_block   = "172.16.0.16/28"
  network_policy           = true
  logging_enabled_components = ["SYSTEM_COMPONENTS","WORKLOADS"]
  monitoring_enabled_components = ["SYSTEM_COMPONENTS"]
  enable_cost_allocation = true
  cluster_autoscaling = {
    "autoscaling_profile": "OPTIMIZE_UTILIZATION",
    "enabled" : true,
    "gpu_resources" : [],
    "min_cpu_cores" : 36,
    "min_memory_gb" : 144,
    "max_cpu_cores" : 70,
    "max_memory_gb" : 250,
  }
    monitoring_enable_managed_prometheus = true
  gke_backup_agent_config = true

  node_pools = [
    {
      name            = "pool-kafka"
      autoscaling     = true
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-8"
      node_locations  = "us-west1-a,us-west1-b,us-west1-c"
      auto_repair     = true
    },
    {
      name            = "pool-zookeeper"
      autoscaling     = true
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-8"
      node_locations  = "us-west1-a,us-west1-b,us-west1-c"
      auto_repair     = true
    },
  ]
  node_pools_labels = {
    all = {}
    pool-kafka = {
      "app.stateful/component" = "kafka-broker"
    }
    pool-zookeeper = {
      "app.stateful/component" = "zookeeper"
    }
  }
  node_pools_taints = {
    all = []
    pool-kafka = [
      {
        key    = "app.stateful/component"
        value  = "kafka-broker"
        effect = "NO_SCHEDULE"
      },
    ],
    pool-zookeeper = [
      {
        key    = "app.stateful/component"
        value  = "zookeeper"
        effect = "NO_SCHEDULE"
      },
    ],
  }
 gce_pd_csi_driver = true
}
# [END gke_standard_private_regional_backup_cluster]
