variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the document"
  type        = string

  validation {
    condition     = can(regex("^.+$", var.name))
    error_message = "resource_aws_ssm_document, name must be a non-empty string."
  }
}

variable "attachments_source" {
  description = "One or more configuration blocks describing attachments sources to a version of a document"
  type = list(object({
    key    = string
    values = list(string)
    name   = optional(string)
  }))
  default = null

  validation {
    condition = var.attachments_source == null ? true : alltrue([
      for attachment in var.attachments_source : contains(["SourceUrl", "S3FileUrl", "AttachmentReference"], attachment.key)
    ])
    error_message = "resource_aws_ssm_document, attachments_source key must be one of: SourceUrl, S3FileUrl, AttachmentReference."
  }
}

variable "content" {
  description = "The content for the SSM document in JSON or YAML format"
  type        = string

  validation {
    condition     = can(regex("^.+$", var.content))
    error_message = "resource_aws_ssm_document, content must be a non-empty string."
  }
}

variable "document_format" {
  description = "The format of the document"
  type        = string
  default     = "JSON"

  validation {
    condition     = contains(["JSON", "TEXT", "YAML"], var.document_format)
    error_message = "resource_aws_ssm_document, document_format must be one of: JSON, TEXT, YAML."
  }
}

variable "document_type" {
  description = "The type of the document"
  type        = string

  validation {
    condition     = can(regex("^.+$", var.document_type))
    error_message = "resource_aws_ssm_document, document_type must be a non-empty string."
  }
}

variable "permissions" {
  description = "Additional permissions to attach to the document"
  type = object({
    type        = string
    account_ids = string
  })
  default = null

  validation {
    condition     = var.permissions == null ? true : var.permissions.type == "Share"
    error_message = "resource_aws_ssm_document, permissions type must be 'Share'."
  }
}

variable "target_type" {
  description = "The target type which defines the kinds of resources the document can run on"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the object"
  type        = map(string)
  default     = {}
}

variable "version_name" {
  description = "The version of the artifact associated with the document"
  type        = string
  default     = null
}