variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "policy" {
  description = "The text of the policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_cloudwatch_event_bus_policy, policy must be valid JSON."
  }
}

variable "event_bus_name" {
  description = "The name of the event bus to set the permissions on. If you omit this, the permissions are set on the default event bus."
  type        = string
  default     = null
}