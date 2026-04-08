variable "portfolio_id" {
  description = "Portfolio identifier"
  type        = string

  validation {
    condition     = length(var.portfolio_id) > 0
    error_message = "resource_aws_servicecatalog_portfolio_share, portfolio_id must be a non-empty string."
  }
}

variable "principal_id" {
  description = "Identifier of the principal with whom you will share the portfolio. Valid values AWS account IDs and ARNs of AWS Organizations and organizational units"
  type        = string

  validation {
    condition     = length(var.principal_id) > 0
    error_message = "resource_aws_servicecatalog_portfolio_share, principal_id must be a non-empty string."
  }
}

variable "type" {
  description = "Type of portfolio share. Valid values are ACCOUNT (an external account), ORGANIZATION (a share to every account in an organization), ORGANIZATIONAL_UNIT, ORGANIZATION_MEMBER_ACCOUNT (a share to an account in an organization)"
  type        = string

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION", "ORGANIZATIONAL_UNIT", "ORGANIZATION_MEMBER_ACCOUNT"], var.type)
    error_message = "resource_aws_servicecatalog_portfolio_share, type must be one of: ACCOUNT, ORGANIZATION, ORGANIZATIONAL_UNIT, ORGANIZATION_MEMBER_ACCOUNT."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code. Valid values: en (English), jp (Japanese), zh (Chinese). Default value is en"
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "resource_aws_servicecatalog_portfolio_share, accept_language must be one of: en, jp, zh."
  }
}

variable "share_principals" {
  description = "Enables or disables Principal sharing when creating the portfolio share. If this flag is not provided, principal sharing is disabled"
  type        = bool
  default     = null
}

variable "share_tag_options" {
  description = "Whether to enable sharing of aws_servicecatalog_tag_option resources when creating the portfolio share"
  type        = bool
  default     = null
}

variable "wait_for_acceptance" {
  description = "Whether to wait (up to the timeout) for the share to be accepted. Organizational shares are automatically accepted"
  type        = bool
  default     = null
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "3m"
}

variable "timeouts_read" {
  description = "Timeout for read operation"
  type        = string
  default     = "10m"
}

variable "timeouts_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "3m"
}

variable "timeouts_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "3m"
}