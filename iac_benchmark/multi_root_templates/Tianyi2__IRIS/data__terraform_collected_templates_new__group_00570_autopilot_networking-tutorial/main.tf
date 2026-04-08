# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gke_ap_networking_tutorial_create_cluster]

terraform {
  required_version = "~> 1.3"
}
 
provider "google" {}
 
variable "region" {
  type        = string
  description = "Region where the cluster will be created."
  default     = "us-central1"
}
 
variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "networking-cluster"
}
 
resource "google_container_cluster" "default" {
  name             = var.cluster_name
  description      = "Cluster for sample web application"
  location         = var.region
  enable_autopilot = true
 
  ip_allocation_policy {}
}
 
output "region" {
  value       = var.region
  description = "Compute region"
}
 
output "cluster_name" {
  value       = google_container_cluster.default.name
  description = "Cluster name"
}

# [END gke_ap_networking_tutorial_create_cluster]
