variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "load_balancer_name" {
  description = "The load balancer to attach the policy to."
  type        = string

  validation {
    condition     = length(var.load_balancer_name) > 0
    error_message = "resource_aws_load_balancer_listener_policy, load_balancer_name must not be empty."
  }
}

variable "load_balancer_port" {
  description = "The load balancer listener port to apply the policy to."
  type        = number

  validation {
    condition     = var.load_balancer_port >= 1 && var.load_balancer_port <= 65535
    error_message = "resource_aws_load_balancer_listener_policy, load_balancer_port must be between 1 and 65535."
  }
}

variable "policy_names" {
  description = "List of Policy Names to apply to the backend server."
  type        = list(string)

  validation {
    condition     = length(var.policy_names) > 0
    error_message = "resource_aws_load_balancer_listener_policy, policy_names must contain at least one policy name."
  }

  validation {
    condition     = alltrue([for name in var.policy_names : length(name) > 0])
    error_message = "resource_aws_load_balancer_listener_policy, policy_names cannot contain empty strings."
  }
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger an update."
  type        = map(string)
  default     = null
}