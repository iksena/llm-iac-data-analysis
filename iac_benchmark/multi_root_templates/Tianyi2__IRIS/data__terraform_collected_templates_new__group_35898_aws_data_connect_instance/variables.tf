variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Returns information on a specific connect instance by id"
  type        = string
  default     = null

  validation {
    condition     = var.instance_id == null || can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_instance, instance_id must be a valid UUID format."
  }
}

variable "instance_alias" {
  description = "Returns information on a specific connect instance by alias"
  type        = string
  default     = null

  validation {
    condition     = var.instance_alias == null || length(var.instance_alias) > 0
    error_message = "data_aws_connect_instance, instance_alias must not be empty if provided."
  }
}

