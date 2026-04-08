variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_opensearchserverless_security_policy, name must not be empty."
  }
}

variable "type" {
  description = "Type of security policy. One of encryption or network."
  type        = string

  validation {
    condition     = contains(["encryption", "network"], var.type)
    error_message = "data_aws_opensearchserverless_security_policy, type must be either 'encryption' or 'network'."
  }
}