variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "key_name" {
  description = "The name for the key pair. If neither key_name nor key_name_prefix is provided, Terraform will create a unique key name using the prefix terraform-."
  type        = string
  default     = null

  validation {
    condition     = var.key_name == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,254}$", var.key_name))
    error_message = "resource_aws_key_pair, key_name must be a valid key pair name."
  }
}

variable "key_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with key_name. If neither key_name nor key_name_prefix is provided, Terraform will create a unique key name using the prefix terraform-."
  type        = string
  default     = null

  validation {
    condition     = var.key_name_prefix == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,99}$", var.key_name_prefix))
    error_message = "resource_aws_key_pair, key_name_prefix must be a valid key pair name prefix."
  }
}

variable "public_key" {
  description = "The public key material."
  type        = string

  validation {
    condition     = length(var.public_key) > 0
    error_message = "resource_aws_key_pair, public_key cannot be empty."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}