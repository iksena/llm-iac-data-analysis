variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the resource share to retrieve"
  type        = string
  default     = null
}

variable "resource_owner" {
  description = "Owner of the resource share. Valid values are SELF or OTHER-ACCOUNTS"
  type        = string

  validation {
    condition     = contains(["SELF", "OTHER-ACCOUNTS"], var.resource_owner)
    error_message = "data_aws_ram_resource_share, resource_owner must be either 'SELF' or 'OTHER-ACCOUNTS'."
  }
}

variable "resource_share_status" {
  description = "Specifies that you want to retrieve details of only those resource shares that have this status. Valid values are PENDING, ACTIVE, FAILED, DELETING, and DELETED"
  type        = string
  default     = null

  validation {
    condition     = var.resource_share_status == null || contains(["PENDING", "ACTIVE", "FAILED", "DELETING", "DELETED"], var.resource_share_status)
    error_message = "data_aws_ram_resource_share, resource_share_status must be one of: 'PENDING', 'ACTIVE', 'FAILED', 'DELETING', or 'DELETED'."
  }
}

variable "filter" {
  description = "Filter used to scope the list of owned shares e.g., by tags"
  type = object({
    name   = string
    values = list(string)
  })
  default = null

  validation {
    condition = var.filter == null || (
      var.filter.name != null &&
      var.filter.values != null &&
      length(var.filter.values) > 0
    )
    error_message = "data_aws_ram_resource_share, filter must have both 'name' and 'values' specified, and values must not be empty."
  }
}