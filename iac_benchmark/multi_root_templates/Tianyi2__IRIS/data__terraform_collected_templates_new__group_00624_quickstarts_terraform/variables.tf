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

# [START gke_ap_autopilot_quickstart_variables_terraform]
variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "region" {
  description = "The region the cluster in"
  default     = "us-central1"
}


locals {
  cluster_type           = "simple-autopilot-public"
  network_name           = "simple-autopilot-public-network"
  subnet_name            = "simple-autopilot-public-subnet"
  master_auth_subnetwork = "simple-autopilot-public-master-subnet"
  pods_range_name        = "ip-range-pods-simple-autopilot-public"
  svc_range_name         = "ip-range-svc-simple-autopilot-public"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
  ingress_IP             = google_compute_global_address.gke_ingress_ipv4.address
  certificate_host       = ["ingress.quickstart-playground.com", "quickstart-playground.com"]
}
# [END gke_ap_autopilot_quickstart_variables_terraform]
