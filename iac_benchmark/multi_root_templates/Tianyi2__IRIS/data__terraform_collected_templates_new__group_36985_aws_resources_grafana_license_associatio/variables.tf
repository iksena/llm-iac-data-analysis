variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "grafana_token" {
  description = "A token from Grafana Labs that ties your AWS account with a Grafana Labs account."
  type        = string
  default     = null
  sensitive   = true
}

variable "license_type" {
  description = "The type of license for the workspace license association."
  type        = string

  validation {
    condition     = contains(["ENTERPRISE", "ENTERPRISE_FREE_TRIAL"], var.license_type)
    error_message = "resource_aws_grafana_license_association, license_type must be either 'ENTERPRISE' or 'ENTERPRISE_FREE_TRIAL'."
  }
}

variable "workspace_id" {
  description = "The workspace id."
  type        = string

  validation {
    condition     = can(regex("^g-[a-z0-9]{10}$", var.workspace_id))
    error_message = "resource_aws_grafana_license_association, workspace_id must be a valid Grafana workspace ID (format: g-xxxxxxxxxx)."
  }
}