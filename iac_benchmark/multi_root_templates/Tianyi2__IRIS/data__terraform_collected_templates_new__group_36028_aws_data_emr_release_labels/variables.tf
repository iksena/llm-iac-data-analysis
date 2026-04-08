variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filters" {
  description = "Filters the results of the request. Prefix specifies the prefix of release labels to return. Application specifies the application (with/without version) of release labels to return."
  type = object({
    application = optional(string)
    prefix      = optional(string)
  })
  default = null

  validation {
    condition     = var.filters == null || can(var.filters.application) || can(var.filters.prefix)
    error_message = "data_aws_emr_release_labels, filters must contain at least one of 'application' or 'prefix' when specified."
  }
}