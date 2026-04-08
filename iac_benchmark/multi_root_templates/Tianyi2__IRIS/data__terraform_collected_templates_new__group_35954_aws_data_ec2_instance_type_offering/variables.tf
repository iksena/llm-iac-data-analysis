variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "location_type" {
  description = "Location type. Defaults to region. Valid values: availability-zone, availability-zone-id, and region."
  type        = string
  default     = "region"

  validation {
    condition = contains([
      "availability-zone",
      "availability-zone-id",
      "region"
    ], var.location_type)
    error_message = "data_aws_ec2_instance_type_offering, location_type must be one of: availability-zone, availability-zone-id, region."
  }
}

variable "preferred_instance_types" {
  description = "Ordered list of preferred EC2 Instance Types. The first match in this list will be returned. If no preferred matches are found and the original search returned more than one result, an error is returned."
  type        = list(string)
  default     = []
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters. See the EC2 API Reference for supported filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && length(f.name) > 0
    ])
    error_message = "data_aws_ec2_instance_type_offering, filter name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_instance_type_offering, filter values must contain at least one value."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"
}