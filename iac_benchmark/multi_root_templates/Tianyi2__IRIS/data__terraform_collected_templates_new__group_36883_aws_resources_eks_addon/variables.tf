variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "addon_name" {
  description = "Name of the EKS add-on. The name must match one of the names returned by describe-addon-versions."
  type        = string

  validation {
    condition     = length(var.addon_name) > 0
    error_message = "resource_aws_eks_addon, addon_name must be a non-empty string."
  }
}

variable "cluster_name" {
  description = "Name of the EKS Cluster."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_eks_addon, cluster_name must be a non-empty string."
  }
}

variable "addon_version" {
  description = "The version of the EKS add-on. The version must match one of the versions returned by describe-addon-versions."
  type        = string
  default     = null
}

variable "configuration_values" {
  description = "Custom configuration values for addons with single JSON string. This JSON string value must match the JSON schema derived from describe-addon-configuration."
  type        = string
  default     = null
}

variable "resolve_conflicts_on_create" {
  description = "How to resolve field value conflicts when migrating a self-managed add-on to an Amazon EKS add-on. Valid values are NONE and OVERWRITE."
  type        = string
  default     = null

  validation {
    condition     = var.resolve_conflicts_on_create == null || contains(["NONE", "OVERWRITE"], var.resolve_conflicts_on_create)
    error_message = "resource_aws_eks_addon, resolve_conflicts_on_create must be either 'NONE' or 'OVERWRITE'."
  }
}

variable "resolve_conflicts_on_update" {
  description = "How to resolve field value conflicts for an Amazon EKS add-on if you've changed a value from the Amazon EKS default value. Valid values are NONE, OVERWRITE, and PRESERVE."
  type        = string
  default     = null

  validation {
    condition     = var.resolve_conflicts_on_update == null || contains(["NONE", "OVERWRITE", "PRESERVE"], var.resolve_conflicts_on_update)
    error_message = "resource_aws_eks_addon, resolve_conflicts_on_update must be one of 'NONE', 'OVERWRITE', or 'PRESERVE'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "pod_identity_association" {
  description = "Configuration block with EKS Pod Identity association settings."
  type = object({
    role_arn        = string
    service_account = string
  })
  default = null

  validation {
    condition = var.pod_identity_association == null || (
      length(var.pod_identity_association.role_arn) > 0 &&
      length(var.pod_identity_association.service_account) > 0
    )
    error_message = "resource_aws_eks_addon, pod_identity_association role_arn and service_account must be non-empty strings when pod_identity_association is specified."
  }
}

variable "preserve" {
  description = "Indicates if you want to preserve the created resources when deleting the EKS add-on."
  type        = bool
  default     = null
}

variable "service_account_role_arn" {
  description = "The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account. The role must be assigned the IAM permissions required by the add-on."
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "40m")
  })
  default = {
    create = "20m"
    update = "20m"
    delete = "40m"
  }
}