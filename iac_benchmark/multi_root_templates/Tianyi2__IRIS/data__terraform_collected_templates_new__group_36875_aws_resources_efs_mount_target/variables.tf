variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "file_system_id" {
  description = "The ID of the file system for which the mount target is intended."
  type        = string

  validation {
    condition     = var.file_system_id != null && var.file_system_id != ""
    error_message = "resource_aws_efs_mount_target, file_system_id must be provided and cannot be empty."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet to add the mount target in."
  type        = string

  validation {
    condition     = var.subnet_id != null && var.subnet_id != ""
    error_message = "resource_aws_efs_mount_target, subnet_id must be provided and cannot be empty."
  }
}

variable "ip_address" {
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target."
  type        = string
  default     = null
}

variable "ip_address_type" {
  description = "IP address type for the mount target. Valid values are IPV4_ONLY (only IPv4 addresses), IPV6_ONLY (only IPv6 addresses), and DUAL_STACK (dual-stack, both IPv4 and IPv6 addresses). Defaults to IPV4_ONLY."
  type        = string
  default     = "IPV4_ONLY"

  validation {
    condition     = contains(["IPV4_ONLY", "IPV6_ONLY", "DUAL_STACK"], var.ip_address_type)
    error_message = "resource_aws_efs_mount_target, ip_address_type must be one of: IPV4_ONLY, IPV6_ONLY, DUAL_STACK."
  }
}

variable "ipv6_address" {
  description = "IPv6 address to use. Valid only when ip_address_type is set to IPV6_ONLY or DUAL_STACK."
  type        = string
  default     = null

  validation {
    condition = var.ipv6_address == null || (
      var.ip_address_type == "IPV6_ONLY" || var.ip_address_type == "DUAL_STACK"
    )
    error_message = "resource_aws_efs_mount_target, ipv6_address is only valid when ip_address_type is set to IPV6_ONLY or DUAL_STACK."
  }
}

variable "security_groups" {
  description = "A list of up to 5 VPC security group IDs (that must be for the same VPC as subnet specified) in effect for the mount target."
  type        = list(string)
  default     = null

  validation {
    condition     = var.security_groups == null || length(var.security_groups) <= 5
    error_message = "resource_aws_efs_mount_target, security_groups can contain at most 5 security group IDs."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the EFS mount target."
  type        = string
  default     = "30m"
}

variable "timeouts_delete" {
  description = "Timeout for deleting the EFS mount target."
  type        = string
  default     = "10m"
}