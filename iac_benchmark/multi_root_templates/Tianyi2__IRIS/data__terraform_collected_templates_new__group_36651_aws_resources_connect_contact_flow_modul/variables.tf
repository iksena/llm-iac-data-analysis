variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "resource_aws_connect_contact_flow_module, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Specifies the name of the Contact Flow Module."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 127
    error_message = "resource_aws_connect_contact_flow_module, name must be between 1 and 127 characters."
  }
}

variable "description" {
  description = "Specifies the description of the Contact Flow Module."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 500
    error_message = "resource_aws_connect_contact_flow_module, description must be 500 characters or less."
  }
}

variable "content" {
  description = "Specifies the content of the Contact Flow Module, provided as a JSON string, written in Amazon Connect Contact Flow Language. If defined, the filename argument cannot be used."
  type        = string
  default     = null

  validation {
    condition     = var.content == null || can(jsondecode(var.content))
    error_message = "resource_aws_connect_contact_flow_module, content must be valid JSON when provided."
  }
}

variable "content_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the Contact Flow Module source specified with filename."
  type        = string
  default     = null

  validation {
    condition     = var.content_hash == null || can(regex("^[A-Za-z0-9+/]{43}=$", var.content_hash))
    error_message = "resource_aws_connect_contact_flow_module, content_hash must be a valid base64-encoded SHA256 hash."
  }
}

variable "filename" {
  description = "The path to the Contact Flow Module source within the local filesystem. Conflicts with content."
  type        = string
  default     = null

  validation {
    condition     = var.filename == null || length(var.filename) > 0
    error_message = "resource_aws_connect_contact_flow_module, filename must not be empty when provided."
  }

  validation {
    condition     = (var.content == null && var.filename != null) || (var.content != null && var.filename == null) || (var.content == null && var.filename == null)
    error_message = "resource_aws_connect_contact_flow_module, filename conflicts with content - only one can be specified."
  }
}

variable "tags" {
  description = "Tags to apply to the Contact Flow Module."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9 _.:/=+\\-@]{1,128}$", k))
    ])
    error_message = "resource_aws_connect_contact_flow_module, tags keys must be valid AWS tag keys (1-128 characters, alphanumeric, spaces, and _.:/=+-@ characters)."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9 _.:/=+\\-@]{0,256}$", v))
    ])
    error_message = "resource_aws_connect_contact_flow_module, tags values must be valid AWS tag values (0-256 characters, alphanumeric, spaces, and _.:/=+-@ characters)."
  }
}