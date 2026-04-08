variable "domain_identifier" {
  description = "Identifier of domain which the project is part of"
  type        = string

  validation {
    condition     = can(regex("^dzd[-_][a-zA-Z0-9_-]{1,36}$", var.domain_identifier))
    error_message = "resource_aws_datazone_project, domain_identifier must follow the regex pattern ^dzd[-_][a-zA-Z0-9_-]{1,36}$"
  }
}

variable "name" {
  description = "Name of the project"
  type        = string

  validation {
    condition     = can(regex("^[\\w -]+$", var.name))
    error_message = "resource_aws_datazone_project, name must follow the regex pattern ^[\\w -]+$"
  }

  validation {
    condition     = length(var.name) <= 64
    error_message = "resource_aws_datazone_project, name must have a length of at most 64 characters"
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "skip_deletion_check" {
  description = "Optional flag to delete all child entities within the project"
  type        = bool
  default     = null
}

variable "description" {
  description = "Description of project"
  type        = string
  default     = null
}

variable "glossary_terms" {
  description = "List of glossary terms that can be used in the project"
  type        = list(string)
  default     = null

  validation {
    condition = var.glossary_terms == null ? true : (
      length(var.glossary_terms) > 0 && length(var.glossary_terms) <= 20
    )
    error_message = "resource_aws_datazone_project, glossary_terms list cannot be empty or include over 20 values"
  }

  validation {
    condition = var.glossary_terms == null ? true : alltrue([
      for term in var.glossary_terms : can(regex("^[a-zA-Z0-9_-]{1,36}$", term))
    ])
    error_message = "resource_aws_datazone_project, glossary_terms each value must follow the regex pattern [a-zA-Z0-9_-]{1,36}$"
  }
}