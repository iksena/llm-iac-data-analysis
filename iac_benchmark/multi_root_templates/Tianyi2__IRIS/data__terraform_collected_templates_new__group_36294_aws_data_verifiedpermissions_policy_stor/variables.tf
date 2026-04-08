variable "id" {
  description = "The ID of the Policy Store."
  type        = string

  validation {
    condition     = length(var.id) > 0
    error_message = "data_aws_verifiedpermissions_policy_store, id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_verifiedpermissions_policy_store, region must be a valid AWS region format or null."
  }
}