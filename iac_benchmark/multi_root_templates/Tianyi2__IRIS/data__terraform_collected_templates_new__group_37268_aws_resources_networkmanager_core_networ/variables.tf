variable "core_network_id" {
  description = "ID of the core network that a policy will be attached to and made LIVE"
  type        = string

  validation {
    condition     = length(var.core_network_id) > 0
    error_message = "resource_aws_networkmanager_core_network_policy_attachment, core_network_id cannot be empty."
  }
}

variable "policy_document" {
  description = "Policy document for creating a core network. Note that updating this argument will result in the new policy document version being set as the LATEST and LIVE policy document"
  type        = string

  validation {
    condition     = length(var.policy_document) > 0
    error_message = "resource_aws_networkmanager_core_network_policy_attachment, policy_document cannot be empty."
  }
}

variable "timeouts_update" {
  description = "Update timeout configuration. If this is the first time attaching a policy to a core network then this timeout value is also used as the create timeout value"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^([0-9]+[smh])+$", var.timeouts_update))
    error_message = "resource_aws_networkmanager_core_network_policy_attachment, timeouts_update must be a valid duration format (e.g., '30m', '1h', '90s')."
  }
}