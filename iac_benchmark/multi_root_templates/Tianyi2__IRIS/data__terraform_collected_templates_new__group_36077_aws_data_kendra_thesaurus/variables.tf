variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "index_id" {
  description = "Identifier of the index that contains the Thesaurus."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.index_id))
    error_message = "data_aws_kendra_thesaurus, index_id must be a valid UUID format."
  }
}

variable "thesaurus_id" {
  description = "Identifier of the Thesaurus."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.thesaurus_id))
    error_message = "data_aws_kendra_thesaurus, thesaurus_id must be a valid UUID format."
  }
}