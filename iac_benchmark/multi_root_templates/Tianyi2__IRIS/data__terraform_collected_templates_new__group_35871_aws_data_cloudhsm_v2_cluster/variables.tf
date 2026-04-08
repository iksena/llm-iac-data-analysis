variable "cluster_id" {
  description = "ID of Cloud HSM v2 cluster."
  type        = string

  validation {
    condition     = can(regex("^cluster-[a-zA-Z0-9]+$", var.cluster_id))
    error_message = "data_aws_cloudhsm_v2_cluster, cluster_id must be a valid CloudHSM cluster ID starting with 'cluster-'."
  }
}

variable "cluster_state" {
  description = "State of the cluster to be found."
  type        = string
  default     = null

  validation {
    condition = var.cluster_state == null || contains([
      "CREATE_IN_PROGRESS",
      "UNINITIALIZED",
      "INITIALIZE_IN_PROGRESS",
      "INITIALIZED",
      "ACTIVE",
      "UPDATE_IN_PROGRESS",
      "DELETE_IN_PROGRESS",
      "DELETED",
      "DEGRADED"
    ], var.cluster_state)
    error_message = "data_aws_cloudhsm_v2_cluster, cluster_state must be one of: CREATE_IN_PROGRESS, UNINITIALIZED, INITIALIZE_IN_PROGRESS, INITIALIZED, ACTIVE, UPDATE_IN_PROGRESS, DELETE_IN_PROGRESS, DELETED, DEGRADED."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_cloudhsm_v2_cluster, region must be a valid AWS region identifier."
  }
}