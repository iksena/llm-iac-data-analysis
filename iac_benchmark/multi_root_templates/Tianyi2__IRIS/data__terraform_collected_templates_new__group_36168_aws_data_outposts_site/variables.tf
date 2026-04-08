variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_outposts_site, region must be a valid AWS region identifier or null."
  }
}

variable "id" {
  description = "Identifier of the Site."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || length(var.id) > 0
    error_message = "data_aws_outposts_site, id must be a non-empty string or null."
  }
}

variable "name" {
  description = "Name of the Site."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_outposts_site, name must be a non-empty string or null."
  }
}