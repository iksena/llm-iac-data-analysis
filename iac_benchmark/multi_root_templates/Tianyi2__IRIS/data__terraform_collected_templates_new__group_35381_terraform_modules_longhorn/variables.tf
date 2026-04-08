# Helm Chart vars
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
  default     = null
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

# Longhorn specific vars
variable "ingress_enabled" {
  description = "Whether to enable ingress for Longhorn."
  type        = bool
  default     = false
}

variable "ingress_class_name" {
  description = "The ingress class name to use for the Longhorn ingress."
  type        = string
  default     = "nginx"
}

variable "ingress_annotations" {
  description = "A map of annotations to add to the Longhorn ingress."
  type        = map
  default     = {}
}

variable "ingress_tls_enabled" {
  description = "Whether to enable TLS for the Longhorn ingress."
  type        = bool
  default     = true
}

variable "ingress_host_address" {
  description = "The host address for the Longhorn web ingress."
  type        = string
  default     = "longhorn.local"
}

variable "service_type" {
  description = "The type of Kubernetes service to create for Longhorn."
  type        = string
  default     = "ClusterIP"
}

variable "storage_class_name" {
  description = "The storage class name to create."
  type        = string
  default     = "longhorn"
}

variable "storage_replica_count" {
  description = "The number of replicas for the storage class."
  type        = number
  default     = 2
}

variable "storage_reclaim_policy" {
  description = "The reclaim policy for the storage class."
  type        = string
  default     = "Delete"
}

variable "storage_default_path" {
  description = "The default path for the storage class."
  type        = string
  default     = "/var/lib/longhorn"
}
