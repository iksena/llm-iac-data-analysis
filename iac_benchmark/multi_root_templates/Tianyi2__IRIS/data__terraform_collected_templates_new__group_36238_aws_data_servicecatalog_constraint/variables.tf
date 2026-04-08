variable "id" {
  description = "Constraint identifier"
  type        = string
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
    error_message = "data_aws_servicecatalog_constraint, accept_language must be one of: en, jp, zh."
  }
}