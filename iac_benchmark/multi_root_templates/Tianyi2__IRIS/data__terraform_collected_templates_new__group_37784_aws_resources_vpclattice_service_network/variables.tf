variable "name" {
  description = "Name of the service network"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auth_type" {
  description = "Type of IAM policy. Either NONE or AWS_IAM."
  type        = string
  default     = null

  validation {
    condition     = var.auth_type == null || contains(["NONE", "AWS_IAM"], var.auth_type)
    error_message = "resource_aws_vpclattice_service_network, auth_type must be either 'NONE' or 'AWS_IAM'."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}