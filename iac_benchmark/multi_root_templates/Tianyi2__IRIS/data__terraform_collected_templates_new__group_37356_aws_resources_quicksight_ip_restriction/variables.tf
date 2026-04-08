variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_ip_restriction, aws_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "enabled" {
  description = "Whether IP rules are turned on."
  type        = bool

  validation {
    condition     = can(var.enabled)
    error_message = "resource_aws_quicksight_ip_restriction, enabled must be a boolean value (true or false)."
  }
}

variable "ip_restriction_rule_map" {
  description = "Map of allowed IPv4 CIDR ranges and descriptions."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for cidr, desc in var.ip_restriction_rule_map : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_quicksight_ip_restriction, ip_restriction_rule_map keys must be valid IPv4 CIDR ranges."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}[a-z]$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^cn-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_quicksight_ip_restriction, region must be a valid AWS region format."
  }
}

variable "vpc_endpoint_id_restriction_rule_map" {
  description = "Map of allowed VPC endpoint IDs and descriptions."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for vpc_endpoint_id, desc in var.vpc_endpoint_id_restriction_rule_map : can(regex("^vpce-[0-9a-f]{8}([0-9a-f]{9})?$", vpc_endpoint_id))
    ])
    error_message = "resource_aws_quicksight_ip_restriction, vpc_endpoint_id_restriction_rule_map keys must be valid VPC endpoint IDs starting with 'vpce-'."
  }
}

variable "vpc_id_restriction_rule_map" {
  description = "Map of VPC IDs and descriptions. Traffic from all VPC endpoints that are present in the specified VPC is allowed."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for vpc_id, desc in var.vpc_id_restriction_rule_map : can(regex("^vpc-[0-9a-f]{8}([0-9a-f]{9})?$", vpc_id))
    ])
    error_message = "resource_aws_quicksight_ip_restriction, vpc_id_restriction_rule_map keys must be valid VPC IDs starting with 'vpc-'."
  }
}