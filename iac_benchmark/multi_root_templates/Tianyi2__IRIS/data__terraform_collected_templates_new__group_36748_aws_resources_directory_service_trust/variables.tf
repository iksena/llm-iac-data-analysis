variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "conditional_forwarder_ip_addrs" {
  description = "Set of IPv4 addresses for the DNS server associated with the remote Directory. Can contain between 1 and 4 values."
  type        = list(string)
  default     = null

  validation {
    condition = var.conditional_forwarder_ip_addrs == null || (
      length(var.conditional_forwarder_ip_addrs) >= 1 &&
      length(var.conditional_forwarder_ip_addrs) <= 4 &&
      alltrue([
        for ip in var.conditional_forwarder_ip_addrs :
        can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", ip))
      ])
    )
    error_message = "resource_aws_directory_service_trust, conditional_forwarder_ip_addrs must contain between 1 and 4 valid IPv4 addresses."
  }
}

variable "delete_associated_conditional_forwarder" {
  description = "Whether to delete the conditional forwarder when deleting the Trust relationship."
  type        = bool
  default     = null
}

variable "directory_id" {
  description = "ID of the Directory."
  type        = string

  validation {
    condition     = var.directory_id != null && var.directory_id != ""
    error_message = "resource_aws_directory_service_trust, directory_id is required and cannot be empty."
  }
}

variable "remote_domain_name" {
  description = "Fully qualified domain name of the remote Directory."
  type        = string

  validation {
    condition     = var.remote_domain_name != null && var.remote_domain_name != ""
    error_message = "resource_aws_directory_service_trust, remote_domain_name is required and cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.remote_domain_name))
    error_message = "resource_aws_directory_service_trust, remote_domain_name must be a valid fully qualified domain name."
  }
}

variable "selective_auth" {
  description = "Whether to enable selective authentication. Valid values are Enabled and Disabled. Default value is Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.selective_auth)
    error_message = "resource_aws_directory_service_trust, selective_auth must be either 'Enabled' or 'Disabled'."
  }
}

variable "trust_direction" {
  description = "The direction of the Trust relationship. Valid values are 'One-Way: Outgoing', 'One-Way: Incoming', and 'Two-Way'."
  type        = string

  validation {
    condition     = var.trust_direction != null && var.trust_direction != ""
    error_message = "resource_aws_directory_service_trust, trust_direction is required and cannot be empty."
  }

  validation {
    condition     = contains(["One-Way: Outgoing", "One-Way: Incoming", "Two-Way"], var.trust_direction)
    error_message = "resource_aws_directory_service_trust, trust_direction must be one of 'One-Way: Outgoing', 'One-Way: Incoming', or 'Two-Way'."
  }
}

variable "trust_password" {
  description = "Password for the Trust. Can contain upper- and lower-case letters, numbers, and punctuation characters. May be up to 128 characters long."
  type        = string
  sensitive   = true

  validation {
    condition     = var.trust_password != null && var.trust_password != ""
    error_message = "resource_aws_directory_service_trust, trust_password is required and cannot be empty."
  }

  validation {
    condition     = length(var.trust_password) <= 128
    error_message = "resource_aws_directory_service_trust, trust_password may be up to 128 characters long."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9!@#$%^&*()_+\\-=\\[\\]{};':\"\\|,.<>\\/?`~]+$", var.trust_password))
    error_message = "resource_aws_directory_service_trust, trust_password can contain upper- and lower-case letters, numbers, and punctuation characters."
  }
}

variable "trust_type" {
  description = "Type of the Trust relationship. Valid values are Forest and External. Default value is Forest."
  type        = string
  default     = "Forest"

  validation {
    condition     = contains(["Forest", "External"], var.trust_type)
    error_message = "resource_aws_directory_service_trust, trust_type must be either 'Forest' or 'External'."
  }
}