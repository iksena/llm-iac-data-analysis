variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether or not to enable the destination."
  type        = bool
  default     = true
}

variable "vpc_configuration" {
  description = "Configuration of the virtual private cloud (VPC) connection."
  type = object({
    role_arn        = string
    security_groups = optional(list(string))
    subnet_ids      = list(string)
    vpc_id          = string
  })

  validation {
    condition     = var.vpc_configuration.role_arn != null && var.vpc_configuration.role_arn != ""
    error_message = "resource_aws_iot_topic_rule_destination, role_arn must be provided and cannot be empty."
  }

  validation {
    condition     = length(var.vpc_configuration.subnet_ids) > 0
    error_message = "resource_aws_iot_topic_rule_destination, subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition     = var.vpc_configuration.vpc_id != null && var.vpc_configuration.vpc_id != ""
    error_message = "resource_aws_iot_topic_rule_destination, vpc_id must be provided and cannot be empty."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.vpc_configuration.role_arn))
    error_message = "resource_aws_iot_topic_rule_destination, role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.vpc_configuration.subnet_ids :
      can(regex("^subnet-[0-9a-f]{8,17}$", subnet_id))
    ])
    error_message = "resource_aws_iot_topic_rule_destination, subnet_ids must contain valid subnet IDs."
  }

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_configuration.vpc_id))
    error_message = "resource_aws_iot_topic_rule_destination, vpc_id must be a valid VPC ID."
  }

  validation {
    condition = var.vpc_configuration.security_groups == null || alltrue([
      for sg_id in var.vpc_configuration.security_groups :
      can(regex("^sg-[0-9a-f]{8,17}$", sg_id))
    ])
    error_message = "resource_aws_iot_topic_rule_destination, security_groups must contain valid security group IDs when provided."
  }
}