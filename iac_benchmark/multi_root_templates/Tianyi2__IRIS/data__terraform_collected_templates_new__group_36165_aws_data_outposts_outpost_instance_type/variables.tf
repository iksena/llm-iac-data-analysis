variable "arn" {
  description = "Outpost ARN"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:outposts:", var.arn))
    error_message = "data_aws_outposts_outpost_instance_type, arn must be a valid Outpost ARN starting with 'arn:aws:outposts:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Desired instance type. Conflicts with preferred_instance_types"
  type        = string
  default     = null
}

variable "preferred_instance_types" {
  description = "Ordered list of preferred instance types. The first match in this list will be returned. If no preferred matches are found and the original search returned more than one result, an error is returned. Conflicts with instance_type"
  type        = list(string)
  default     = null

  validation {
    condition     = var.preferred_instance_types == null || length(var.preferred_instance_types) > 0
    error_message = "data_aws_outposts_outpost_instance_type, preferred_instance_types must contain at least one instance type when specified."
  }
}