variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the SSL negotiation policy."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_lb_ssl_negotiation_policy, name must not be empty."
  }
}

variable "load_balancer" {
  description = "The load balancer to which the policy should be attached."
  type        = string

  validation {
    condition     = length(var.load_balancer) > 0
    error_message = "resource_aws_lb_ssl_negotiation_policy, load_balancer must not be empty."
  }
}

variable "lb_port" {
  description = "The load balancer port to which the policy should be applied. This must be an active listener on the load balancer."
  type        = number

  validation {
    condition     = var.lb_port > 0 && var.lb_port <= 65535
    error_message = "resource_aws_lb_ssl_negotiation_policy, lb_port must be between 1 and 65535."
  }
}

variable "attribute" {
  description = "An SSL Negotiation policy attribute. Each has two properties: name and value."
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for attr in var.attribute : length(attr.name) > 0
    ])
    error_message = "resource_aws_lb_ssl_negotiation_policy, attribute name must not be empty."
  }

  validation {
    condition = alltrue([
      for attr in var.attribute : length(attr.value) > 0
    ])
    error_message = "resource_aws_lb_ssl_negotiation_policy, attribute value must not be empty."
  }
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger a redeployment."
  type        = map(string)
  default     = {}
}