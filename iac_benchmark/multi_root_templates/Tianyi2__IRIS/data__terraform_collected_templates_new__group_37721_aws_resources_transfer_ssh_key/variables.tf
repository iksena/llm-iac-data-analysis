variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_transfer_ssh_key, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "server_id" {
  description = "The Server ID of the Transfer Server (e.g., s-12345678)"
  type        = string

  validation {
    condition     = can(regex("^s-[a-f0-9]{8,17}$", var.server_id))
    error_message = "resource_aws_transfer_ssh_key, server_id must be a valid Transfer Server ID format (e.g., s-12345678)."
  }
}

variable "user_name" {
  description = "The name of the user account that is assigned to one or more servers"
  type        = string

  validation {
    condition     = length(var.user_name) >= 1 && length(var.user_name) <= 100 && can(regex("^[a-zA-Z0-9._-]+$", var.user_name))
    error_message = "resource_aws_transfer_ssh_key, user_name must be 1-100 characters long and contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "body" {
  description = "The public key portion of an SSH key pair"
  type        = string

  validation {
    condition     = length(var.body) > 0 && can(regex("^(ssh-rsa|ssh-dss|ssh-ed25519|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521) ", var.body))
    error_message = "resource_aws_transfer_ssh_key, body must be a valid SSH public key starting with ssh-rsa, ssh-dss, ssh-ed25519, or ecdsa-sha2-*."
  }
}