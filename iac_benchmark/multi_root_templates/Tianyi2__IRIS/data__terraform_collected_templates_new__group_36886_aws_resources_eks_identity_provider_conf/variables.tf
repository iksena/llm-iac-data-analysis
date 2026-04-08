variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_eks_identity_provider_config, cluster_name cannot be empty."
  }
}

variable "oidc_client_id" {
  description = "Client ID for the OpenID Connect identity provider"
  type        = string

  validation {
    condition     = length(var.oidc_client_id) > 0
    error_message = "resource_aws_eks_identity_provider_config, oidc_client_id cannot be empty."
  }
}

variable "oidc_groups_claim" {
  description = "The JWT claim that the provider will use to return groups"
  type        = string
  default     = null
}

variable "oidc_groups_prefix" {
  description = "A prefix that is prepended to group claims"
  type        = string
  default     = null
}

variable "oidc_identity_provider_config_name" {
  description = "The name of the identity provider config"
  type        = string

  validation {
    condition     = length(var.oidc_identity_provider_config_name) > 0
    error_message = "resource_aws_eks_identity_provider_config, oidc_identity_provider_config_name cannot be empty."
  }
}

variable "oidc_issuer_url" {
  description = "Issuer URL for the OpenID Connect identity provider"
  type        = string

  validation {
    condition     = length(var.oidc_issuer_url) > 0
    error_message = "resource_aws_eks_identity_provider_config, oidc_issuer_url cannot be empty."
  }

  validation {
    condition     = can(regex("^https://", var.oidc_issuer_url))
    error_message = "resource_aws_eks_identity_provider_config, oidc_issuer_url must be a valid HTTPS URL."
  }
}

variable "oidc_required_claims" {
  description = "The key value pairs that describe required claims in the identity token"
  type        = map(string)
  default     = null
}

variable "oidc_username_claim" {
  description = "The JWT claim that the provider will use as the username"
  type        = string
  default     = null
}

variable "oidc_username_prefix" {
  description = "A prefix that is prepended to username claims"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the identity provider configuration"
  type        = string
  default     = "40m"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.create_timeout))
    error_message = "resource_aws_eks_identity_provider_config, create_timeout must be a valid duration (e.g., '40m', '1h')."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the identity provider configuration"
  type        = string
  default     = "40m"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.delete_timeout))
    error_message = "resource_aws_eks_identity_provider_config, delete_timeout must be a valid duration (e.g., '40m', '1h')."
  }
}