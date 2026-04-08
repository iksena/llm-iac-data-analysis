variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Fully-qualified domain name to look up. If no domain name is found, an error will be returned."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "data_aws_api_gateway_domain_name, domain_name must not be empty."
  }
}

variable "domain_name_id" {
  description = "The identifier for the domain name resource. Supported only for private custom domain names."
  type        = string
  default     = null
}