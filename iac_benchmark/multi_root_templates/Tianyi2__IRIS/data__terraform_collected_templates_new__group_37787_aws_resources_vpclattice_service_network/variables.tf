variable "vpc_identifier" {
  description = "The ID of the VPC."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_identifier))
    error_message = "resource_aws_vpclattice_service_network_vpc_association, vpc_identifier must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "service_network_identifier" {
  description = "The ID or Amazon Resource Identifier (ARN) of the service network. You must use the ARN if the resources specified in the operation are in different accounts."
  type        = string

  validation {
    condition     = can(regex("^(sn-[a-zA-Z0-9]+|arn:aws:vpc-lattice:[a-z0-9-]+:[0-9]{12}:servicenetwork/sn-[a-zA-Z0-9]+)$", var.service_network_identifier))
    error_message = "resource_aws_vpclattice_service_network_vpc_association, service_network_identifier must be a valid service network ID starting with 'sn-' or a valid ARN."
  }
}

variable "security_group_ids" {
  description = "The IDs of the security groups."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_ids == null || (
      var.security_group_ids != null &&
      alltrue([for sg in var.security_group_ids : can(regex("^sg-[a-zA-Z0-9]+$", sg))])
    )
    error_message = "resource_aws_vpclattice_service_network_vpc_association, security_group_ids must be a list of valid security group IDs starting with 'sg-'."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]{1,128}$", k))
    ])
    error_message = "resource_aws_vpclattice_service_network_vpc_association, tags keys must be valid AWS tag keys (1-128 characters)."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]{0,256}$", v))
    ])
    error_message = "resource_aws_vpclattice_service_network_vpc_association, tags values must be valid AWS tag values (0-256 characters)."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts != null &&
      (var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create))) &&
      (var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete)))
    )
    error_message = "resource_aws_vpclattice_service_network_vpc_association, timeouts create and delete must be valid duration strings (e.g., '5m', '30s', '1h')."
  }
}