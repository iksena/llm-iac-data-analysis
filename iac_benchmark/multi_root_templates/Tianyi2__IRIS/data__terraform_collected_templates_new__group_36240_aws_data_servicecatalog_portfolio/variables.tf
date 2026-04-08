variable "id" {
  description = "Portfolio identifier"
  type        = string

  validation {
    condition     = length(var.id) > 0
    error_message = "data_aws_servicecatalog_portfolio, id must not be empty."
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
  default     = null

  validation {
    condition     = var.accept_language == null || can(regex("^(en|jp|zh)$", var.accept_language))
    error_message = "data_aws_servicecatalog_portfolio, accept_language must be one of: en, jp, zh."
  }
}