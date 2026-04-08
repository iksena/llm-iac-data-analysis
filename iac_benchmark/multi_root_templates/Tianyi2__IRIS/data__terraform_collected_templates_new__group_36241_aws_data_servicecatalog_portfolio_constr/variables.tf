variable "portfolio_id" {
  description = "Portfolio identifier"
  type        = string

  validation {
    condition     = length(var.portfolio_id) > 0
    error_message = "data_aws_servicecatalog_portfolio_constraints, portfolio_id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code. Valid values: en (English), jp (Japanese), zh (Chinese). Default value is en"
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "data_aws_servicecatalog_portfolio_constraints, accept_language must be one of: en, jp, zh."
  }
}

variable "product_id" {
  description = "Product identifier"
  type        = string
  default     = null
}