variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_autoscaling_attachment, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "autoscaling_group_name" {
  description = "Name of ASG to associate with the ELB."
  type        = string

  validation {
    condition     = length(var.autoscaling_group_name) > 0
    error_message = "resource_aws_autoscaling_attachment, autoscaling_group_name cannot be empty."
  }

  validation {
    condition     = length(var.autoscaling_group_name) <= 255
    error_message = "resource_aws_autoscaling_attachment, autoscaling_group_name must be 255 characters or less."
  }
}

variable "elb" {
  description = "Name of the ELB."
  type        = string
  default     = null

  validation {
    condition     = var.elb == null || (length(var.elb) > 0 && length(var.elb) <= 32)
    error_message = "resource_aws_autoscaling_attachment, elb must be between 1 and 32 characters when specified."
  }

  validation {
    condition     = var.elb == null || can(regex("^[a-zA-Z0-9-]+$", var.elb))
    error_message = "resource_aws_autoscaling_attachment, elb must contain only alphanumeric characters and hyphens when specified."
  }
}

variable "lb_target_group_arn" {
  description = "ARN of a load balancer target group."
  type        = string
  default     = null

  validation {
    condition     = var.lb_target_group_arn == null || can(regex("^arn:aws[a-zA-Z-]*:elasticloadbalancing:[a-z0-9-]+:[0-9]{12}:targetgroup/[a-zA-Z0-9-]+/[a-zA-Z0-9]+$", var.lb_target_group_arn))
    error_message = "resource_aws_autoscaling_attachment, lb_target_group_arn must be a valid target group ARN when specified."
  }
}

variable "attachment_type_validation" {
  description = "Internal validation to ensure either elb or lb_target_group_arn is specified, but not both."
  type        = string
  default     = "validate"

  validation {
    condition     = var.attachment_type_validation == "validate"
    error_message = "resource_aws_autoscaling_attachment, attachment_type_validation requires exactly one of elb or lb_target_group_arn to be specified."
  }
}