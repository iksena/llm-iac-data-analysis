variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "network_interface_id" {
  description = "The ID of the network interface."
  type        = string

  validation {
    condition     = can(regex("^eni-", var.network_interface_id))
    error_message = "resource_aws_network_interface_permission, network_interface_id must be a valid ENI ID starting with 'eni-'."
  }
}

variable "aws_account_id" {
  description = "The Amazon Web Services account ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_network_interface_permission, aws_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "permission" {
  description = "The type of permission to grant. Valid values are INSTANCE-ATTACH or EIP-ASSOCIATE."
  type        = string

  validation {
    condition     = contains(["INSTANCE-ATTACH", "EIP-ASSOCIATE"], var.permission)
    error_message = "resource_aws_network_interface_permission, permission must be either 'INSTANCE-ATTACH' or 'EIP-ASSOCIATE'."
  }
}