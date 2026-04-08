/**
 * Copyright 2020 Taito United
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

/* Helm */

variable "helm_enabled" {
  type        = bool
  default     = "false"
  description = "Installs helm apps if set to true. Should be set to true only after Kubernetes cluster already exists."
}

/* Labeling */

variable "name" {
  type        = string
  description = "Name that groups all the created resources together. Preferably globally unique to avoid naming conflicts."
}

/* DO provider */

variable "do_token" {
  type        = string
  description = "Digital Ocean personal access token."
}

variable "spaces_access_id" {
  type        = string
  description = "Digital Ocean Spaces access id."
}

variable "spaces_secret_key" {
  type        = string
  description = "Digital Ocean Spaces secret key."
}

variable "region" {
  type = string
  description = "Digital Ocean region."
}

/* Settings */

variable "email" {
  type        = string
  description = "Email address for DevOps support."
}

/* Buckets */

variable "state_bucket" {
  type        = string
  default     = ""
  description = "Name of storage bucket used for storing remote Terraform state."
}

# Resources as a json/yaml

variable "resources" {
  type        = any
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
