variable "region" {
  type        = string
  description = "Region where this resource will be managed"
  default     = null
}

variable "name" {
  type        = string
  description = "Name of the alias"

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_gamelift_alias, name must not be empty."
  }
}

variable "description" {
  type        = string
  description = "Description of the alias"
  default     = null
}

variable "routing_strategy" {
  type = object({
    fleet_id = optional(string)
    message  = optional(string)
    type     = string
  })
  description = "Specifies the fleet and/or routing type to use for the alias"

  validation {
    condition     = contains(["SIMPLE", "TERMINAL"], var.routing_strategy.type)
    error_message = "resource_aws_gamelift_alias, routing_strategy.type must be either 'SIMPLE' or 'TERMINAL'."
  }

  validation {
    condition = (
      var.routing_strategy.type == "SIMPLE" ? var.routing_strategy.fleet_id != null :
      var.routing_strategy.type == "TERMINAL" ? var.routing_strategy.message != null :
      true
    )
    error_message = "resource_aws_gamelift_alias, routing_strategy when type is 'SIMPLE', fleet_id is required; when type is 'TERMINAL', message is required."
  }
}

variable "tags" {
  type        = map(string)
  description = "Key-value map of resource tags"
  default     = {}
}