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

# Velero vars
variable "bucket_access_id" {
  description = "The access ID for the object storage bucket used by Velero."
  type        = string
}

variable "bucket_access_key" {
  description = "The access key for the object storage bucket used by Velero."
  type        = string
  sensitive   = true
}

variable "bucket_region" {
  description = "The region where the object storage bucket used by Velero is located."
  type        = string
}

variable "bucket_name" {
  description = "The name of the object storage bucket used by Velero."
  type        = string
}

variable "bucket_endpoint" {
  description = "The endpoint URL for the object storage bucket used by Velero."
  type        = string
}

variable "dns_policy" {
  description = "The DNS policy to set for Velero pods."
  type        = string
  default     = "ClusterFirst"
}

variable "internal_kubectl_repository" {
  description = "The repository URL for the kubectl image used by Velero."
  type        = string
  default     = "bitnamilegacy/kubectl"
}

variable "internal_kubectl_tag" {
  description = "The version tag for the kubectl image used by Velero. If null, deployed cluster version is used."
  type        = string
  default     = null
}

variable "aws_plugin_tag" {
  description = "The version tag for the Velero AWS plugin image."
  type        = string
  default     = "latest"
}

variable "scheduled_backups" {
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

variable "scheduled_backup_common_labels" {
  description = "Common labels to apply to all scheduled backups."
  type        = map(string)
  default     = {}
}

variable "scheduled_backup_common_annotations" {
  description = "Common annotations to apply to all scheduled backups."
  type        = map(string)
  default     = {}
}
