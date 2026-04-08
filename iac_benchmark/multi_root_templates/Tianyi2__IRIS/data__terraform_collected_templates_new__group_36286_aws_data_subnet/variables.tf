variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability zone where the subnet must reside."
  type        = string
  default     = null
}

variable "availability_zone_id" {
  description = "ID of the Availability Zone for the subnet. This argument is not supported in all regions or partitions. If necessary, use availability_zone instead."
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "CIDR block of the desired subnet."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_block == null || can(cidrhost(var.cidr_block, 0))
    error_message = "data_aws_subnet, cidr_block must be a valid CIDR block."
  }
}

variable "default_for_az" {
  description = "Whether the desired subnet must be the default subnet for its associated availability zone."
  type        = bool
  default     = null
}

variable "filter" {
  description = "Configuration block for complex filters. You can use one or more filter blocks."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_subnet, filter name must be provided and cannot be empty."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_subnet, filter values must contain at least one value."
  }
}

variable "id" {
  description = "ID of the specific subnet to retrieve."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^subnet-[0-9a-f]{8}([0-9a-f]{9})?$", var.id))
    error_message = "data_aws_subnet, id must be a valid subnet ID (subnet-xxxxxxxx or subnet-xxxxxxxxxxxxxxxxx)."
  }
}

variable "ipv6_cidr_block" {
  description = "IPv6 CIDR block of the desired subnet."
  type        = string
  default     = null

  validation {
    condition     = var.ipv6_cidr_block == null || can(cidrhost(var.ipv6_cidr_block, 0))
    error_message = "data_aws_subnet, ipv6_cidr_block must be a valid IPv6 CIDR block."
  }
}

variable "state" {
  description = "State that the desired subnet must have."
  type        = string
  default     = null

  validation {
    condition     = var.state == null || contains(["pending", "available"], var.state)
    error_message = "data_aws_subnet, state must be either 'pending' or 'available'."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired subnet."
  type        = map(string)
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC that the desired subnet belongs to."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_id == null || can(regex("^vpc-[0-9a-f]{8}([0-9a-f]{9})?$", var.vpc_id))
    error_message = "data_aws_subnet, vpc_id must be a valid VPC ID (vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_subnet, timeouts_read must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}