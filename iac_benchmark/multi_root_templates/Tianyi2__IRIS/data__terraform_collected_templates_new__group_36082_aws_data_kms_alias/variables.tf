variable "name" {
  description = "Display name of the alias. The name must start with the word 'alias' followed by a forward slash (alias/)"
  type        = string

  validation {
    condition     = can(regex("^alias/", var.name))
    error_message = "data_aws_kms_alias, name must start with 'alias/' prefix."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}