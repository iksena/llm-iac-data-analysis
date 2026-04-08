variable "enabled" {
  description = "Whether to enable AWS Organizations access"
  type        = string

  validation {
    condition     = can(regex("^(true|false)$", var.enabled))
    error_message = "resource_aws_servicecatalog_organizations_access, enabled must be either 'true' or 'false'."
  }
}