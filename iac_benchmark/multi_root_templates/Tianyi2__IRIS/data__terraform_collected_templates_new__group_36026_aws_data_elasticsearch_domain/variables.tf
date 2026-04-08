variable "domain_name" {
  description = "Name of the domain"
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "data_elasticsearch_domain, domain_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_elasticsearch_domain, region must not be empty if specified."
  }
}