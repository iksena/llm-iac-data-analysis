variable "portfolio_id" {
  description = "Portfolio identifier."
  type        = string

  validation {
    condition     = length(var.portfolio_id) > 0
    error_message = "resource_aws_servicecatalog_principal_portfolio_association, portfolio_id cannot be empty."
  }
}

variable "principal_arn" {
  description = "Principal ARN."
  type        = string

  validation {
    condition     = length(var.principal_arn) > 0
    error_message = "resource_aws_servicecatalog_principal_portfolio_association, principal_arn cannot be empty."
  }

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::", var.principal_arn))
    error_message = "resource_aws_servicecatalog_principal_portfolio_association, principal_arn must be a valid IAM ARN."
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
    error_message = "resource_aws_servicecatalog_principal_portfolio_association, accept_language must be one of: en, jp, zh."
  }
}

variable "principal_type" {
  description = "Principal type. Valid values are IAM and IAM_PATTERN. Default is IAM."
  type        = string
  default     = "IAM"

  validation {
    condition     = contains(["IAM", "IAM_PATTERN"], var.principal_type)
    error_message = "resource_aws_servicecatalog_principal_portfolio_association, principal_type must be one of: IAM, IAM_PATTERN."
  }

  validation {
    condition     = var.principal_type != ""
    error_message = "resource_aws_servicecatalog_principal_portfolio_association, principal_type cannot be empty."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "3m")
    read   = optional(string, "10m")
    delete = optional(string, "3m")
  })
  default = {
    create = "3m"
    read   = "10m"
    delete = "3m"
  }
}