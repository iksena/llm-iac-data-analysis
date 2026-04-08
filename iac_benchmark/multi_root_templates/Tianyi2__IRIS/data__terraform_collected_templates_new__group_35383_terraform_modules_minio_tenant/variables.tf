# Chart vars
variable "namespace" {
  description = "The namespace in which to deploy the Helm chart."
  type        = string
  default     = null
}

variable "create_namespace" {
  description = "Whether to create the namespace for the module."
  type        = bool
  default     = true
}

variable "chart_install_name" {
  description = "The name used to install the Helm chart."
  type        = string
  default     = "minio-tenant"
}

variable "chart_version" {
  description = "The version of the Helm chart to deploy. If null, the latest version is used."
  type        = string
  default     = null
}

variable "chart_linting_enabled" {
  description = "Whether to enable Helm chart linting."
  type        = bool
  default     = true
}

variable "chart_recreate_pods" {
  description = "Whether to recreate pods when deploying the Helm chart."
  type        = bool
  default     = false
}

variable "chart_upgrade_install" {
  description = "Whether to install the Helm chart if it is not already installed during an upgrade."
  type        = bool
  default     = true
}

variable "chart_replace" {
  description = "Whether to replace the Helm chart if it is already installed."
  type        = bool
  default     = false
}

variable "chart_dependency_update" {
  description = "Whether to update chart dependencies before installing or upgrading the Helm chart."
  type        = bool
  default     = true
}

variable "chart_cleanup_on_fail" {
  description = "Whether to cleanup resources if the Helm chart installation or upgrade fails."
  type        = bool
  default     = true
}


# Minio Tenant vars
variable "buckets" {
  description = "A list of buckets to create in the MinIO tenant."
  type        = list(object({
    name       = string
    region     = string
    objectLock = bool
  }))
  default     = [
    {
      name       = "bucket0"
      region     = "minio"
      objectLock = false
    }
  ]
}

variable "pool_name" {
  description = "The name of the storage pool to use for the MinIO tenant."
  type        = string
  default     = "pool0"
}

variable "pool_size_gb" {
  description = "The size in GB of each volume in the storage pool."
  type        = number
  default     = 10
}

variable "pool_server_count" {
  description = "The number of servers to use in the storage pool."
  type        = number
  default     = 1
}

variable "pool_volume_count" {
  description = "The number of volumes to use per server in the storage pool."
  type        = number
  default     = 1
}

variable "pool_storage_class_name" {
  description = "The storage class name to use for the storage pool volumes."
  type        = string
}

variable "pool_node_selector" {
  description = "A map of node selector labels to use for the storage pool pods."
  type        = map(string)
  default     = {
    "minio.io/storage-node" = "true"
  }
}

variable "pool_tolerations" {
  description = "A list of tolerations to apply to the storage pool pods."
  type        = list
  default     = []
}

variable "pool_user_id" {
  description = "The user ID to use for the MinIO tenant pods."
  type        = number
  default     = 0
}

variable "pool_group_id" {
  description = "The group ID to use for the MinIO tenant pods."
  type        = number
  default     = 0
}

variable "access_id" {
  description = "The access ID for the MinIO tenant."
  type        = string
  default     = "minio_admin"
}

variable "access_key" {
  description = "The access key for the MinIO tenant. If null, a random access key will be generated."
  type        = string
  default     = null
  sensitive   = true
}

variable "request_auto_cert" {
  description = "Whether to request an automatic TLS certificate for the MinIO tenant."
  type        = bool
  default     = false
}
