variable "parameters" {
  description = "Constraint parameters in JSON format. The syntax depends on the constraint type."
  type        = string

  validation {
    condition     = can(jsondecode(var.parameters))
    error_message = "resource_aws_servicecatalog_constraint, parameters must be a valid JSON string."
  }
}

variable "portfolio_id" {
  description = "Portfolio identifier."
  type        = string

  validation {
    condition     = length(var.portfolio_id) > 0
    error_message = "resource_aws_servicecatalog_constraint, portfolio_id cannot be empty."
  }
}

variable "product_id" {
  description = "Product identifier."
  type        = string

  validation {
    condition     = length(var.product_id) > 0
    error_message = "resource_aws_servicecatalog_constraint, product_id cannot be empty."
  }
}

variable "type" {
  description = "Type of constraint. Valid values are LAUNCH, NOTIFICATION, RESOURCE_UPDATE, STACKSET, and TEMPLATE."
  type        = string

  validation {
    condition     = contains(["LAUNCH", "NOTIFICATION", "RESOURCE_UPDATE", "STACKSET", "TEMPLATE"], var.type)
    error_message = "resource_aws_servicecatalog_constraint, type must be one of: LAUNCH, NOTIFICATION, RESOURCE_UPDATE, STACKSET, TEMPLATE."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code. Valid values: en (English), jp (Japanese), zh (Chinese). Default value is en."
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "resource_aws_servicecatalog_constraint, accept_language must be one of: en, jp, zh."
  }
}

variable "description" {
  description = "Description of the constraint."
  type        = string
  default     = null
}