variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "addon_name" {
  description = "Name of the EKS add-on. The name must match one of the names returned by list-addon."
  type        = string

  validation {
    condition     = length(var.addon_name) > 0
    error_message = "data_aws_eks_addon_version, addon_name must not be empty."
  }
}

variable "kubernetes_version" {
  description = "Version of the EKS Cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores."
  type        = string

  validation {
    condition     = length(var.kubernetes_version) >= 1 && length(var.kubernetes_version) <= 100
    error_message = "data_aws_eks_addon_version, kubernetes_version must be between 1-100 characters in length."
  }

  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9\\-_]+$", var.kubernetes_version))
    error_message = "data_aws_eks_addon_version, kubernetes_version must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores."
  }
}

variable "most_recent" {
  description = "Determines if the most recent or default version of the addon should be returned."
  type        = bool
  default     = null
}