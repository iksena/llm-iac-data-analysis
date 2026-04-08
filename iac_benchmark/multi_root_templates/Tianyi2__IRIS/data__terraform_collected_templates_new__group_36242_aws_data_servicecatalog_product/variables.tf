variable "id" {
  description = "ID of the product"
  type        = string

  validation {
    condition     = length(var.id) > 0
    error_message = "data_servicecatalog_product, id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code. Valid values are 'en' (English), 'jp' (Japanese), 'zh' (Chinese). The default value is 'en'"
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "data_servicecatalog_product, accept_language must be one of: en, jp, zh."
  }
}