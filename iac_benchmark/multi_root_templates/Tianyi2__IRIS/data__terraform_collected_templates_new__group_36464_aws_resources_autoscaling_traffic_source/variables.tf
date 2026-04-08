variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "autoscaling_group_name" {
  description = "The name of the Auto Scaling group."
  type        = string

  validation {
    condition     = length(var.autoscaling_group_name) > 0
    error_message = "resource_aws_autoscaling_traffic_source_attachment, autoscaling_group_name must not be empty."
  }
}

variable "traffic_source" {
  description = "The unique identifiers of a traffic sources."
  type = object({
    identifier = string
    type       = string
  })

  validation {
    condition     = length(var.traffic_source.identifier) > 0
    error_message = "resource_aws_autoscaling_traffic_source_attachment, traffic_source.identifier must not be empty."
  }

  validation {
    condition     = contains(["elb", "elbv2", "vpc-lattice"], var.traffic_source.type)
    error_message = "resource_aws_autoscaling_traffic_source_attachment, traffic_source.type must be one of: elb, elbv2, vpc-lattice."
  }
}