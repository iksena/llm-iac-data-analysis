variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the document."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_ssm_document, name cannot be empty."
  }
}

variable "document_format" {
  description = "The format of the document. Valid values: JSON, TEXT, YAML."
  type        = string
  default     = null

  validation {
    condition     = var.document_format == null || can(regex("^(JSON|TEXT|YAML)$", var.document_format))
    error_message = "data_aws_ssm_document, document_format must be one of: JSON, TEXT, YAML."
  }
}

variable "document_version" {
  description = "The document version."
  type        = string
  default     = null
}