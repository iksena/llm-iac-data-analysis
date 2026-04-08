variable "product_id" {
  description = "Product identifier"
  type        = string

  validation {
    condition     = can(regex("^prod-[a-zA-Z0-9]+$", var.product_id))
    error_message = "data_aws_servicecatalog_launch_paths, product_id must be a valid product identifier starting with 'prod-'"
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
    error_message = "data_aws_servicecatalog_launch_paths, accept_language must be one of: en, jp, zh"
  }
}