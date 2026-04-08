variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_opensearchserverless_lifecycle_policy, name must not be null or empty."
  }
}

variable "type" {
  description = "Type of lifecycle policy. Must be 'retention'."
  type        = string

  validation {
    condition     = var.type == "retention"
    error_message = "data_aws_opensearchserverless_lifecycle_policy, type must be 'retention'."
  }
}