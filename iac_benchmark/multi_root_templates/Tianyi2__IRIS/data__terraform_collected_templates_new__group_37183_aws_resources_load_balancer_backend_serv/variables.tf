variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "load_balancer_name" {
  description = "The load balancer to attach the policy to."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,31}$", var.load_balancer_name))
    error_message = "resource_aws_load_balancer_backend_server_policy, load_balancer_name must be a valid load balancer name (1-32 characters, alphanumeric and hyphens, must start with alphanumeric)."
  }
}

variable "policy_names" {
  description = "List of Policy Names to apply to the backend server."
  type        = list(string)

  validation {
    condition     = length(var.policy_names) > 0
    error_message = "resource_aws_load_balancer_backend_server_policy, policy_names must contain at least one policy name."
  }

  validation {
    condition     = alltrue([for name in var.policy_names : can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]{0,127}$", name))])
    error_message = "resource_aws_load_balancer_backend_server_policy, policy_names must contain valid policy names (1-128 characters, alphanumeric, hyphens, underscores, and periods, must start with alphanumeric)."
  }
}

variable "instance_port" {
  description = "The instance port to apply the policy to."
  type        = number

  validation {
    condition     = var.instance_port >= 1 && var.instance_port <= 65535
    error_message = "resource_aws_load_balancer_backend_server_policy, instance_port must be between 1 and 65535."
  }
}