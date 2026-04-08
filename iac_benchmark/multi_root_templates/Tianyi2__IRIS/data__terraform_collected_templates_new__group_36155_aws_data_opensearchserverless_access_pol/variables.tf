variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_opensearchserverless_access_policy, name must be a non-empty string."
  }
}

variable "type" {
  description = "Type of access policy. Must be 'data'"
  type        = string

  validation {
    condition     = var.type == "data"
    error_message = "data_aws_opensearchserverless_access_policy, type must be 'data'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_opensearchserverless_access_policy, region must be a non-empty string or null."
  }
}