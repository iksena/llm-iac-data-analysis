# Chart shared variables
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

# Storage and namespace variables
variable "openebs_enabled" {
  description = "Whether to deploy OpenEBS for storage."
  type        = bool
  default     = true
}

variable "openebs_namespace" {
  description = "The Kubernetes namespace in which to deploy OpenEBS."
  type        = string
  default     = "openebs"
}

variable "create_openebs_namespace" {
  description = "Whether to create the OpenEBS namespace."
  type        = bool
  default     = true
}

variable "longhorn_namespace" {
  description = "The Kubernetes namespace in which to deploy Longhorn."
  type        = string
  default     = "longhorn-system"
}

variable "create_longhorn_namespace" {
  description = "Whether to create the Longhorn namespace."
  type        = bool
  default     = true
}

variable "minio_operator_enabled" {
  description = "Whether to deploy the MinIO Operator."
  type        = bool
  default     = true
}

variable "minio_operator_namespace" {
  description = "The Kubernetes namespace in which to deploy the MinIO Operator."
  type        = string
  default     = "minio-operator"
}

variable "create_minio_operator_namespace" {
  description = "Whether to create the MinIO Operator namespace."
  type        = bool
  default     = true
}

variable "velero_enabled" {
  description = "Whether to deploy Velero with MinIO tenant for backups. Requires MinIO Operator to be enabled."
  type        = bool
  default     = true
}

variable "velero_namespace" {
  description = "The Kubernetes namespace in which to deploy the Velero MinIO tenant."
  type        = string
  default     = "velero"
}

variable "create_velero_namespace" {
  description = "Whether to create the Velero namespace."
  type        = bool
  default     = true
}

variable "velero_minio_pool_user_id" {
  description = "The user ID to run the Velero MinIO tenant pool pods as."
  type        = number
  default     = 1000
}

variable "velero_minio_pool_group_id" {
  description = "The group ID to run the Velero MinIO tenant pool pods as."
  type        = number
  default     = 1000
}

variable "velero_minio_pool_size_gb" {
  description = "The size in GB of each volume in the Velero MinIO tenant pool."
  type        = number
  default     = 32
}

variable "velero_minio_pool_server_count" {
  description = "The number of servers in the Velero MinIO tenant pool."
  type        = number
  default     = 1
}

variable "velero_minio_pool_volume_count" {
  description = "The number of volumes per server in the Velero MinIO tenant pool."
  type        = number
  default     = 1
}

variable "velero_minio_pool_storage_class_name" {
  description = "The storage class name to use for the Velero MinIO tenant pool volumes."
  type        = string
  default     = "standard"
}

variable "velero_minio_pool_node_selector" {
  description = "The node selector to use for the Velero MinIO tenant pool pods."
  type        = map(string)
  default     = {
    "minio.io/storage-node" = "true"
  }
}

variable "velero_minio_pool_tolerations" {
  description = "The tolerations to use for the Velero MinIO tenant pool pods."
  type        = list
  default     = []
}

variable "velero_internal_kubectl_repository" {
  description = "The repository URL for the kubectl image used by Velero."
  type        = string
  default     = "bitnamilegacy/kubectl"
}

variable "velero_internal_kubectl_tag" {
  description = "The version tag for the kubectl image used by Velero. If null, deployed cluster version is used."
  type        = string
  default     = null
}

variable "velero_scheduled_backups" {
  description = "A map of scheduled backup configurations for Velero. Each key is the name of the schedule and the value is an object with respetive attributes."
  type = map(object({
    schedule                  = tuple([string, string, string, string, string])
    ttl_minutes               = optional(number)
    included_namespaces       = optional(list(string))
    excluded_namespaces       = optional(list(string))
    included_resources        = optional(list(string))
    excluded_resources        = optional(list(string))
    include_cluster_resources = optional(bool)
    selected_labels           = optional(map(string))
    storage_location          = optional(string)
    schedule_labels           = optional(map(string))
    schedule_annotations      = optional(map(string))
  }))
  default = {}
}

variable "velero_scheduled_backup_common_labels" {
  description = "Common labels to apply to all Velero scheduled backups."
  type        = map(string)
  default     = {}
}

variable "velero_scheduled_backup_common_annotations" {
  description = "Common annotations to apply to all Velero scheduled backups."
  type        = map(string)
  default     = {}
}

variable "longhorn_version" {
  description = "The chart version of Longhorn to deploy."
  type        = string
  default     = "1.10.1"
}

variable "longhorn_ingress_class_name" {
  description = "The name of the Ingress class to use for Longhorn."
  type        = string
  default     = "nginx"
}

variable "longhorn_ingress_enabled" {
  description = "Whether to enable the Longhorn Ingress."
  type        = bool
  default     = true
}

variable "longhorn_ingress_host_address" {
  description = "The hostname for the Longhorn Ingress."
  type        = string
  default     = "longhorn.local"
}

variable "longhorn_ingress_tls_enabled" {
  description = "Whether to enable TLS for the Longhorn Ingress."
  type        = bool
  default     = true
}

variable "longhorn_ingress_annotations" {
  description = "Annotations to apply to the Longhorn Ingress."
  type        = map(string)
  default     = {}
}

variable "longhorn_storage_replica_count" {
  description = "The number of replicas for Longhorn storage."
  type        = number
  default     = 2
}

variable "longhorn_storage_class_name" {
  description = "The name of the Longhorn storage class to create."
  type        = string
  default     = "longhorn"
}

variable "longhorn_storage_reclaim_policy" {
  description = "The reclaim policy for the Longhorn storage class."
  type        = string
  default     = "Delete"
}

variable "longhorn_storage_default_path" {
  description = "The default path for Longhorn storage across nodes."
  type        = string
  default     = "/var/lib/longhorn"
}
