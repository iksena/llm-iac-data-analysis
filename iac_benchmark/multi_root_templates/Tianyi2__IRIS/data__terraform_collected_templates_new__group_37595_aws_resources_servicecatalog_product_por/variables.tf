variable "portfolio_id" {
  description = "Portfolio identifier."
  type        = string

  validation {
    condition     = length(var.portfolio_id) > 0
    error_message = "resource_aws_servicecatalog_product_portfolio_association, portfolio_id must not be empty."
  }
}

variable "product_id" {
  description = "Product identifier."
  type        = string

  validation {
    condition     = length(var.product_id) > 0
    error_message = "resource_aws_servicecatalog_product_portfolio_association, product_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code. Valid values: en (English), jp (Japanese), zh (Chinese). Default value is en."
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "resource_aws_servicecatalog_product_portfolio_association, accept_language must be one of: en, jp, zh."
  }
}

variable "source_portfolio_id" {
  description = "Identifier of the source portfolio."
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "3m")
    read   = optional(string, "10m")
    delete = optional(string, "3m")
  })
  default = {
    create = "3m"
    read   = "10m"
    delete = "3m"
  }
}