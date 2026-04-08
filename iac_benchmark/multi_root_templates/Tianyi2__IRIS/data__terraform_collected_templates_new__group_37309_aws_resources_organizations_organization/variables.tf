variable "aws_service_access_principals" {
  description = "List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have `feature_set` set to `ALL`. Some services do not support enablement via this endpoint."
  type        = list(string)
  default     = null

  validation {
    condition = var.aws_service_access_principals == null ? true : alltrue([
      for principal in var.aws_service_access_principals :
      can(regex("^[a-zA-Z0-9.-]+\\.amazonaws\\.com$", principal))
    ])
    error_message = "resource_aws_organizations_organization, aws_service_access_principals must be valid AWS service principal names in the format 'service-abbreviation.amazonaws.com'."
  }
}

variable "enabled_policy_types" {
  description = "List of Organizations policy types to enable in the Organization Root. Organization must have `feature_set` set to `ALL`. For additional information about valid policy types (e.g., `AISERVICES_OPT_OUT_POLICY`, `BACKUP_POLICY`, `RESOURCE_CONTROL_POLICY`, `SERVICE_CONTROL_POLICY`, and `TAG_POLICY`)."
  type        = list(string)
  default     = null

  validation {
    condition = var.enabled_policy_types == null ? true : alltrue([
      for policy_type in var.enabled_policy_types :
      contains(["AISERVICES_OPT_OUT_POLICY", "BACKUP_POLICY", "RESOURCE_CONTROL_POLICY", "SERVICE_CONTROL_POLICY", "TAG_POLICY"], policy_type)
    ])
    error_message = "resource_aws_organizations_organization, enabled_policy_types must be one or more of: AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, RESOURCE_CONTROL_POLICY, SERVICE_CONTROL_POLICY, TAG_POLICY."
  }
}

variable "feature_set" {
  description = "Specify \"ALL\" (default) or \"CONSOLIDATED_BILLING\"."
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "CONSOLIDATED_BILLING"], var.feature_set)
    error_message = "resource_aws_organizations_organization, feature_set must be either 'ALL' or 'CONSOLIDATED_BILLING'."
  }
}