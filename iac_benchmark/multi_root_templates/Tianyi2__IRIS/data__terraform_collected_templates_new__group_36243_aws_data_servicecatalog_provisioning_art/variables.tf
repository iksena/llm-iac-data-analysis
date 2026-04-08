variable "product_id" {
  description = "Product identifier"
  type        = string

  validation {
    condition     = var.product_id != null && var.product_id != ""
    error_message = "data_aws_servicecatalog_provisioning_artifacts, product_id must not be null or empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_servicecatalog_provisioning_artifacts, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "accept_language" {
  description = "Language code. Valid values: en (English), jp (Japanese), zh (Chinese). Default value is en"
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "data_aws_servicecatalog_provisioning_artifacts, accept_language must be one of: en, jp, zh."
  }
}