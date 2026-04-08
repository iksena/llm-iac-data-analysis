variable "auto_enable" {
  description = "When this setting is enabled, all new accounts that are created in, or added to, the organization are added as a member accounts of the organization's Detective delegated administrator and Detective is enabled in that AWS Region"
  type        = bool

  validation {
    condition     = can(var.auto_enable)
    error_message = "resource_aws_detective_organization_configuration, auto_enable must be a boolean value."
  }
}

variable "graph_arn" {
  description = "ARN of the behavior graph"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:detective:", var.graph_arn))
    error_message = "resource_aws_detective_organization_configuration, graph_arn must be a valid Detective behavior graph ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_detective_organization_configuration, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}