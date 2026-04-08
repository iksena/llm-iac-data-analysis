variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "load_balancer_name" {
  description = "The load balancer on which the policy is defined."
  type        = string

  validation {
    condition     = length(var.load_balancer_name) > 0
    error_message = "resource_aws_load_balancer_policy, load_balancer_name must not be empty."
  }
}

variable "policy_name" {
  description = "The name of the load balancer policy."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "resource_aws_load_balancer_policy, policy_name must not be empty."
  }
}

variable "policy_type_name" {
  description = "The policy type."
  type        = string

  validation {
    condition     = length(var.policy_type_name) > 0
    error_message = "resource_aws_load_balancer_policy, policy_type_name must not be empty."
  }
}

variable "policy_attribute" {
  description = "Policy attribute to apply to the policy."
  type = list(object({
    name  = string
    value = string
  }))
  default = null

  validation {
    condition = var.policy_attribute == null || (
      var.policy_attribute != null && alltrue([
        for attr in var.policy_attribute : length(attr.name) > 0 && length(attr.value) > 0
      ])
    )
    error_message = "resource_aws_load_balancer_policy, policy_attribute name and value must not be empty when specified."
  }
}