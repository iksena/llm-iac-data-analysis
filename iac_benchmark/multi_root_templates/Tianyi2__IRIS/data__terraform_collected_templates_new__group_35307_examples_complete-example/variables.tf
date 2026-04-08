variable "environment" {
  type        = string
  default     = "account"
  description = "Environment name"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "gcp_project_id" {
  type        = string
  default     = "clouddrove"
  description = "Google Cloud project ID"
}

variable "gcp_region" {
  type        = string
  default     = "europe-west3"
  description = "Google Cloud region"
}

variable "gcp_zone" {
  type        = string
  default     = "Europe-west3-c"
  description = "Google Cloud zone"
}

###################################################
#GKE-NODE-POOL-SERVICE-ACCOUNT
###################################################

variable "gke_sa_account_name" {
  type        = string
  description = "Name of service account"
  default     = "gke-node-pool-sa"
}

variable "gke_sa_display_name" {
  type        = string
  description = "Display name of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "gke-node-pool-sa"
}

variable "description" {
  type        = string
  description = "Default description of the created service accounts (defaults to no description)"
  default     = "predefined gke node pool service account"
}

###################################################
#GKE#
###################################################

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = null
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  type        = string
  default     = null
}

variable "machine_type_critical" {
  description = "Machine type of node"
  type        = string
  default     = null
}

variable "machine_type_application" {
  description = "Machine type of node"
  type        = string
  default     = null
}


variable "node_locations" {
  description = "node location of node"
  type        = string
  default     = null
}

variable "disk_type_critical" {
  description = "disk size for node"
  type        = string
  default     = null
}

variable "disk_type_application" {
  description = "disk size for node"
  type        = string
  default     = null
}

variable "disk_size_gb_critical" {
  description = "disk size for node"
  type        = number
  default     = 10
}

variable "disk_size_gb_application" {
  description = "disk size for node"
  type        = number
  default     = null
}

variable "cluster_resource_labels" {
  type        = map(string)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default     = {}
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
  default     = null
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  type        = string
  default     = null
}
