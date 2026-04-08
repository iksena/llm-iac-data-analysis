# Portions Copyright (c) Microsoft Corporation
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

variable "region" {
  description = "Azure region"
  type        = string
}

variable "region_short" {
  description = "Azure region shorthand"
  type        = string
}

variable "region_vn2" {
  description = "Azure region"
  type        = string
}

variable "region_short_vn2" {
  description = "Azure region shorthand"
  type        = string
}

variable "aks_cluster_name" {
  description = "Azure Kubernetes Service cluster name"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Virtual Node namespace"
  type        = string
  default     = "vn2"
}

variable "aks_resource_group_id" {
  description = "AKS Resource group ID"
  type        = string
}

variable "aks_resource_group_name" {
  description = "AKS Resource group name"
  type        = string
}

variable "vn2_resource_group_id" {
  description = "VN2 Resource group ID"
  type        = string
}

variable "vn2_resource_group_name" {
  description = "VN2 Resource group name"
  type        = string
}

variable "containers" {
  description = "Containers to deploy"
  type = list(object({
    name      = string
    image     = string
    ccepolicy = string
  }))
}
