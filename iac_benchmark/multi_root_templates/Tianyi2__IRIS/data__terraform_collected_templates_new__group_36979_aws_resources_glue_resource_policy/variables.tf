variable "policy" {
  description = "The policy to be applied to the aws glue data catalog"
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_glue_resource_policy, policy must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "enable_hybrid" {
  description = "Indicates that you are using both methods to grant cross-account. Valid values are TRUE and FALSE"
  type        = string
  default     = null

  validation {
    condition     = var.enable_hybrid == null || contains(["TRUE", "FALSE"], var.enable_hybrid)
    error_message = "resource_aws_glue_resource_policy, enable_hybrid must be either 'TRUE' or 'FALSE'."
  }
}