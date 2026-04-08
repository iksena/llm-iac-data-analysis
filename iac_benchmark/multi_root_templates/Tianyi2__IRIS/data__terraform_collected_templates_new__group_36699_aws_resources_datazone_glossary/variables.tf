variable "name" {
  description = "Name of the glossary"
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 256
    error_message = "resource_aws_datazone_glossary, name must have length between 1 and 256."
  }
}

variable "owning_project_identifier" {
  description = "ID of the project that owns business glossary"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,36}$", var.owning_project_identifier))
    error_message = "resource_aws_datazone_glossary, owning_project_identifier must follow regex of ^[a-zA-Z0-9_-]{1,36}$."
  }
}

variable "domain_identifier" {
  description = "Domain identifier for the glossary"
  type        = string
}

variable "description" {
  description = "Description of the glossary"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) >= 0 && length(var.description) <= 4096)
    error_message = "resource_aws_datazone_glossary, description must have a length between 0 and 4096."
  }
}

variable "status" {
  description = "Status of business glossary"
  type        = string
  default     = null

  validation {
    condition     = var.status == null || contains(["DISABLED", "ENABLED"], var.status)
    error_message = "resource_aws_datazone_glossary, status valid values are DISABLED and ENABLED."
  }
}