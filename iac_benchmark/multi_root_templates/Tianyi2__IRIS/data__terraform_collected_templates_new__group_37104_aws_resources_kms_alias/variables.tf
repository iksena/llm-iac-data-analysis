variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The display name of the alias. The name must start with the word 'alias' followed by a forward slash (alias/)"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^alias/", var.name))
    error_message = "resource_aws_kms_alias, name must start with 'alias/' if provided."
  }
}

variable "name_prefix" {
  description = "Creates an unique alias beginning with the specified prefix. The name must start with the word 'alias' followed by a forward slash (alias/). Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^alias/", var.name_prefix))
    error_message = "resource_aws_kms_alias, name_prefix must start with 'alias/' if provided."
  }
}

variable "target_key_id" {
  description = "Identifier for the key for which the alias is for, can be either an ARN or key_id."
  type        = string

  validation {
    condition     = length(var.target_key_id) > 0
    error_message = "resource_aws_kms_alias, target_key_id cannot be empty."
  }
}