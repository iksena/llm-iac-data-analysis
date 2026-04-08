variable "domain_identifier" {
  description = "Identifier of domain"
  type        = string

  validation {
    condition     = length(var.domain_identifier) > 0
    error_message = "resource_aws_datazone_glossary_term, domain_identifier must not be empty."
  }
}

variable "glossary_identifier" {
  description = "Identifier of glossary"
  type        = string

  validation {
    condition     = length(var.glossary_identifier) > 0
    error_message = "resource_aws_datazone_glossary_term, glossary_identifier must not be empty."
  }
}

variable "name" {
  description = "Name of glossary term"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_datazone_glossary_term, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "long_description" {
  description = "Long description of entry"
  type        = string
  default     = null
}

variable "short_description" {
  description = "Short description of entry"
  type        = string
  default     = null
}

variable "status" {
  description = "If glossary term is ENABLED or DISABLED"
  type        = string
  default     = null

  validation {
    condition     = var.status == null || contains(["ENABLED", "DISABLED"], var.status)
    error_message = "resource_aws_datazone_glossary_term, status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "term_relations" {
  description = "Object classifying the term relations"
  type = object({
    classifies = optional(list(string))
    is_as      = optional(string)
  })
  default = null

  validation {
    condition = var.term_relations == null || (
      var.term_relations.classifies == null || (
        length(var.term_relations.classifies) >= 0 &&
        alltrue([for item in var.term_relations.classifies : length(item) > 0])
      )
    )
    error_message = "resource_aws_datazone_glossary_term, term_relations.classifies items must not be empty strings."
  }
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string, "30s")
  })
  default = {
    create = "30s"
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.create))
    error_message = "resource_aws_datazone_glossary_term, timeouts.create must be a valid duration (e.g., '30s', '5m', '1h')."
  }
}