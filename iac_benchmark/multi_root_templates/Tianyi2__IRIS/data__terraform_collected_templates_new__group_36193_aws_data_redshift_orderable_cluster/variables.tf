variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_type" {
  description = "Redshift Cluster type. E.g., multi-node or single-node"
  type        = string
  default     = null

  validation {
    condition     = var.cluster_type == null || contains(["multi-node", "single-node"], var.cluster_type)
    error_message = "data_aws_redshift_orderable_cluster, cluster_type must be either 'multi-node' or 'single-node'."
  }
}

variable "cluster_version" {
  description = "Redshift Cluster version. E.g., 1.0"
  type        = string
  default     = null
}

variable "node_type" {
  description = "Redshift Cluster node type. E.g., dc2.8xlarge"
  type        = string
  default     = null
}

variable "preferred_node_types" {
  description = "Ordered list of preferred Redshift Cluster node types. The first match in this list will be returned. If no preferred matches are found and the original search returned more than one result, an error is returned."
  type        = list(string)
  default     = null

  validation {
    condition     = var.preferred_node_types == null || length(var.preferred_node_types) > 0
    error_message = "data_aws_redshift_orderable_cluster, preferred_node_types must contain at least one element when specified."
  }
}