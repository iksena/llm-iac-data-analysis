variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "faq_id" {
  description = "Identifier of the FAQ."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.faq_id))
    error_message = "data_aws_kendra_faq, faq_id must be a valid UUID format."
  }
}

variable "index_id" {
  description = "Identifier of the index that contains the FAQ."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.index_id))
    error_message = "data_aws_kendra_faq, index_id must be a valid UUID format."
  }
}