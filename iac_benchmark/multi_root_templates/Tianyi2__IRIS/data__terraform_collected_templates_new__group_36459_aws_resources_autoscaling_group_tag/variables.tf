variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "autoscaling_group_name" {
  description = "Name of the Autoscaling Group to apply the tag to."
  type        = string

  validation {
    condition     = length(var.autoscaling_group_name) > 0
    error_message = "resource_aws_autoscaling_group_tag, autoscaling_group_name must not be empty."
  }
}

variable "tag_key" {
  description = "Tag name."
  type        = string

  validation {
    condition     = length(var.tag_key) > 0
    error_message = "resource_aws_autoscaling_group_tag, tag_key must not be empty."
  }
}

variable "tag_value" {
  description = "Tag value."
  type        = string

  validation {
    condition     = length(var.tag_value) > 0
    error_message = "resource_aws_autoscaling_group_tag, tag_value must not be empty."
  }
}

variable "propagate_at_launch" {
  description = "Whether to propagate the tags to instances launched by the ASG."
  type        = bool
}