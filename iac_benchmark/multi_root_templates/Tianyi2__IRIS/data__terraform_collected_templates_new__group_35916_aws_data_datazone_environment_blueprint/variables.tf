variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_id" {
  description = "ID of the domain."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,64}$", var.domain_id))
    error_message = "data_aws_datazone_environment_blueprint, domain_id must be a valid DataZone domain ID."
  }
}

variable "name" {
  description = "Name of the blueprint."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 256
    error_message = "data_aws_datazone_environment_blueprint, name must be between 1 and 256 characters."
  }
}

variable "managed" {
  description = "Whether the blueprint is managed by Amazon DataZone."
  type        = bool

  validation {
    condition     = var.managed != null
    error_message = "data_aws_datazone_environment_blueprint, managed must be specified as true or false."
  }
}