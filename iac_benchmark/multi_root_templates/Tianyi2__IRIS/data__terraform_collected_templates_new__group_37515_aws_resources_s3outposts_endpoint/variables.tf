variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "outpost_id" {
  description = "Identifier of the Outpost to contain this endpoint."
  type        = string
  validation {
    condition     = var.outpost_id != null && var.outpost_id != ""
    error_message = "resource_aws_s3outposts_endpoint, outpost_id cannot be null or empty."
  }
}

variable "security_group_id" {
  description = "Identifier of the EC2 Security Group."
  type        = string
  validation {
    condition     = var.security_group_id != null && var.security_group_id != ""
    error_message = "resource_aws_s3outposts_endpoint, security_group_id cannot be null or empty."
  }
}

variable "subnet_id" {
  description = "Identifier of the EC2 Subnet."
  type        = string
  validation {
    condition     = var.subnet_id != null && var.subnet_id != ""
    error_message = "resource_aws_s3outposts_endpoint, subnet_id cannot be null or empty."
  }
}

variable "access_type" {
  description = "Type of access for the network connectivity. Valid values are Private or CustomerOwnedIp."
  type        = string
  default     = null
  validation {
    condition     = var.access_type == null || contains(["Private", "CustomerOwnedIp"], var.access_type)
    error_message = "resource_aws_s3outposts_endpoint, access_type must be one of: Private, CustomerOwnedIp."
  }
}

variable "customer_owned_ipv4_pool" {
  description = "The ID of a Customer Owned IP Pool."
  type        = string
  default     = null
}