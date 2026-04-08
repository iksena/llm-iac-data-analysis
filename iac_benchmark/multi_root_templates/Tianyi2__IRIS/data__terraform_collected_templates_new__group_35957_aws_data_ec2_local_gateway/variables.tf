variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "filter" {
  description = "Custom filter block"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : can(regex("^[a-zA-Z0-9._-]+$", f.name))
    ])
    error_message = "data_aws_ec2_local_gateway, filter: filter name must be a valid AWS API filter name."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_local_gateway, filter: filter values must contain at least one value."
  }
}

variable "id" {
  description = "Id of the specific Local Gateway to retrieve"
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^lgw-[a-f0-9]{8,17}$", var.id))
    error_message = "data_aws_ec2_local_gateway, id: must be a valid Local Gateway ID (lgw-xxxxxxxx)."
  }
}

variable "state" {
  description = "Current state of the desired Local Gateway"
  type        = string
  default     = null

  validation {
    condition     = var.state == null || contains(["pending", "available"], var.state)
    error_message = "data_aws_ec2_local_gateway, state: must be either 'pending' or 'available'."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired Local Gateway"
  type        = map(string)
  default     = null
}

variable "timeouts_read" {
  description = "How long to wait for the Local Gateway data to be retrieved"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[ms]$", var.timeouts_read))
    error_message = "data_aws_ec2_local_gateway, timeouts_read: must be a valid timeout duration (e.g., '20m', '30s')."
  }
}