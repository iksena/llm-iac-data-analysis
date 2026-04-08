variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "ID of the application."
  type        = string

  validation {
    condition     = length(var.application_id) > 0
    error_message = "resource_aws_servicecatalogappregistry_attribute_group_association, application_id must not be empty."
  }
}

variable "attribute_group_id" {
  description = "ID of the attribute group to associate with the application."
  type        = string

  validation {
    condition     = length(var.attribute_group_id) > 0
    error_message = "resource_aws_servicecatalogappregistry_attribute_group_association, attribute_group_id must not be empty."
  }
}