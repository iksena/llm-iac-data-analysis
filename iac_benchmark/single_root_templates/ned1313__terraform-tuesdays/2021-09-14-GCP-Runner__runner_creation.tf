# ── main.tf ────────────────────────────────────
/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  network_name    = var.create_network ? google_compute_network.gh-network[0].self_link : var.network_name
  subnet_name     = var.create_network ? google_compute_subnetwork.gh-subnetwork[0].self_link : var.subnet_name
  startup_script  = var.startup_script == "" ? file("${path.module}/scripts/startup.sh") : var.startup_script
  shutdown_script = var.shutdown_script == "" ? file("${path.module}/scripts/shutdown.sh") : var.shutdown_script
}

/*****************************************
  Optional Runner Networking
 *****************************************/
resource "google_compute_network" "gh-network" {
  count                   = var.create_network ? 1 : 0
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "gh-subnetwork" {
  count         = var.create_network ? 1 : 0
  project       = var.project_id
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip
  region        = var.region
  network       = google_compute_network.gh-network[0].name
}

resource "google_compute_router" "default" {
  count   = var.create_network ? 1 : 0
  name    = "${var.network_name}-router"
  network = google_compute_network.gh-network[0].self_link
  region  = var.region
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  count                              = var.create_network ? 1 : 0
  project                            = var.project_id
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.default[0].name
  region                             = google_compute_router.default[0].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

/*****************************************
  Runner Secrets
 *****************************************/
resource "google_secret_manager_secret" "gh-secret" {
  provider  = google-beta
  project   = var.project_id
  secret_id = "gh-token"

  labels = {
    label = "gh-token"
  }

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}
resource "google_secret_manager_secret_version" "gh-secret-version" {
  provider = google-beta
  secret   = google_secret_manager_secret.gh-secret.id
  secret_data = jsonencode({
    "ORG_NAME"     = var.org_name
    "ORG_URL"      = var.org_url
    "GITHUB_TOKEN" = var.gh_token
  })
}


resource "google_secret_manager_secret_iam_member" "gh-secret-member" {
  provider  = google-beta
  project   = var.project_id
  secret_id = google_secret_manager_secret.gh-secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account}"
}

/*****************************************
  Runner GCE Instance Template
 *****************************************/
locals {
  instance_name = "gh-runner-vm"
}


module "mig_template" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 7.0"
  project_id         = var.project_id
  machine_type       = var.machine_type
  network            = local.network_name
  subnetwork         = local.subnet_name
  region             = var.region
  subnetwork_project = var.subnetwork_project != "" ? var.subnetwork_project : var.project_id
  service_account = {
    email = var.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  disk_size_gb         = 100
  disk_type            = "pd-ssd"
  auto_delete          = true
  name_prefix          = "gh-runner"
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  startup_script       = local.startup_script
  source_image         = var.source_image
  metadata = merge({
    "secret-id" = google_secret_manager_secret_version.gh-secret-version.name
    }, {
    "shutdown-script" = local.shutdown_script
  }, var.custom_metadata)
  tags = [
    "gh-runner-vm"
  ]
}
/*****************************************
  Runner MIG
 *****************************************/
module "mig" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  version            = "~> 7.0"
  project_id         = var.project_id
  subnetwork_project = var.project_id
  hostname           = local.instance_name
  region             = var.region
  instance_template  = module.mig_template.self_link
  target_size        = var.target_size

  /* autoscaler */
  autoscaling_enabled = true
  cooldown_period     = var.cooldown_period
}


# ── variables.tf ────────────────────────────────────
/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type        = string
  description = "The project id to deploy Github Runner"
}
variable "region" {
  type        = string
  description = "The GCP region to deploy instances into"
  default     = "us-east4"
}

variable "zone" {
  type        = string
  description = "The GCP zone to deploy instances into"
  default     = "us-east4-b"
}

variable "network_name" {
  type        = string
  description = "Name for the VPC network"
  default     = "gh-runner-network"
}

variable "create_network" {
  type        = bool
  description = "When set to true, VPC,router and NAT will be auto created"
  default     = true
}

variable "subnetwork_project" {
  type        = string
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the project_id is used."
  default     = ""
}

variable "subnet_ip" {
  type        = string
  description = "IP range for the subnet"
  default     = "10.10.10.0/24"
}
variable "subnet_name" {
  type        = string
  description = "Name for the subnet"
  default     = "gh-runner-subnet"
}

variable "restart_policy" {
  type        = string
  description = "The desired Docker restart policy for the runner image"
  default     = "Always"
}

variable "org_url" {
  type        = string
  description = "Org URL for the Github Action"
}

variable "org_name" {
  type        = string
  description = "Name of the org for the Github Action"
}

variable "gh_token" {
  type        = string
  description = "Github token that is used for generating Self Hosted Runner Token"
}

variable "instance_name" {
  type        = string
  description = "The gce instance name"
  default     = "gh-runner"
}

variable "target_size" {
  type        = number
  description = "The number of runner instances"
  default     = 1
}

variable "service_account" {
  description = "Service account email address"
  type        = string
  default     = ""
}
variable "additional_metadata" {
  type        = map(any)
  description = "Additional metadata to attach to the instance"
  default     = {}
}
variable "machine_type" {
  type        = string
  description = "The GCP machine type to deploy"
  default     = "n1-standard-1"
}

variable "source_image_family" {
  type        = string
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public Ubuntu image."
  default     = "ubuntu-minimal-1804-lts"
}

variable "source_image_project" {
  type        = string
  description = "Project where the source image comes from"
  default     = "ubuntu-os-cloud"
}

variable "source_image" {
  type        = string
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "startup_script" {
  type        = string
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "shutdown_script" {
  type        = string
  description = "User shutdown script to run when instances shutdown"
  default     = ""
}

variable "custom_metadata" {
  type        = map(any)
  description = "User provided custom metadata"
  default     = {}
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  default     = 60
}


# ── versions.tf ────────────────────────────────────
/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  required_version = ">= 0.13"
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 3.53"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.53"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-github-actions-runners:gh-runner-mig-vm/v1.0.1"
  }

  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-github-actions-runners:gh-runner-mig-vm/v1.0.1"
  }

}


# ── output.tf ────────────────────────────────────
/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "mig-instance-group" {
  description = "The instance group url of the created MIG"
  value       = module.mig.instance_group
}

output "mig-name" {
  description = "The name of the MIG"
  value       = local.instance_name
}

output "mig-instance-template" {
  description = "The name of the MIG Instance Template"
  value       = module.mig_template.name
}

output "network_name" {
  description = "Name of VPC"
  value       = local.network_name
}

output "subnet_name" {
  description = "Name of VPC"
  value       = local.subnet_name
}

output "gh_secret_id" {
  description = "Secret Manager ID and version of the github secrets (token, repo_name,repo_owner)"
  value       = google_secret_manager_secret_version.gh-secret-version.name
}


